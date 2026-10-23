<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import { api } from '../lib/api';
import { useAuth } from '../stores/auth';
import { useCart } from '../stores/cart';
import { useConfirm } from '../stores/confirm';

const router = useRouter();
const { state, isMerchant, setUser } = useAuth();
const { clear: clearCart } = useCart();
const { ask } = useConfirm();

const form = reactive({
    name: '',
    company_name: '',
    phone: '',
    address: '',
    city: '',
    cuisine_type: '',
    description: '',
});

const loading = ref(true);
const saving = ref(false);
const deleting = ref(false);
const error = ref('');
const success = ref('');

const roleLabel = computed(() => (isMerchant.value ? 'Akun Dapur Katering' : 'Akun Kantor Perusahaan'));

onMounted(async () => {
    try {
        const payload = await api.get('/profile');
        Object.assign(form, {
            name: payload.user.name,
            company_name: payload.user.company_name,
            phone: payload.user.phone,
            address: payload.user.address,
            city: payload.user.city,
            cuisine_type: payload.user.cuisine_type || '',
            description: payload.user.description || '',
        });
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
});

async function save() {
    saving.value = true;
    error.value = '';
    success.value = '';

    try {
        const payload = {
            name: form.name,
            company_name: form.company_name,
            phone: form.phone,
            address: form.address,
            city: form.city,
            description: form.description,
        };

        if (isMerchant.value) {
            payload.cuisine_type = form.cuisine_type;
        }

        const response = await api.put('/profile', payload);
        setUser(response.user);
        success.value = 'Profil Anda berhasil diperbarui.';
        setTimeout(() => {
            if (success.value === 'Profil Anda berhasil diperbarui.') {
                success.value = '';
            }
        }, 4000);
    } catch (err) {
        error.value = err.message;
    } finally {
        saving.value = false;
    }
}

async function deleteAccount() {
    const isCatering = isMerchant.value;

    const confirmed = await ask({
        title: isCatering ? 'Hapus Akun Katering Permanen?' : 'Hapus Akun Kantor Permanen?',
        message: isCatering
            ? 'Tindakan ini akan menghapus akun katering, seluruh menu hidangan, dan riwayat pesanan dapur Anda secara permanen dari GoCatering. Data tidak dapat dipulihkan kembali.'
            : 'Tindakan ini akan menghapus akun kantor Anda, riwayat pesanan, serta semua faktur invoice perusahaan secara permanen dari sistem.',
        confirmText: 'Ya, Hapus Akun Saya',
        cancelText: 'Batalkan',
        type: 'danger',
    });

    if (!confirmed) {
        return;
    }

    deleting.value = true;
    error.value = '';

    try {
        await api.delete('/profile');
        setUser(null);
        clearCart();
        router.push('/');
    } catch (err) {
        error.value = err.message;
    } finally {
        deleting.value = false;
    }
}
</script>

<template>
    <div class="mx-auto max-w-3xl px-5 py-12">
        <!-- Page Title & Header -->
        <div class="mb-8">
            <span
                class="rounded-full px-3.5 py-1 text-xs font-bold uppercase tracking-wider"
                :class="isMerchant ? 'bg-amber-100 text-amber-800' : 'bg-stone-200 text-stone-800'"
            >
                {{ roleLabel }}
            </span>
            <h1 class="mt-3 font-display text-3xl font-extrabold tracking-tight text-stone-900 sm:text-4xl">
                Pengaturan Profil
            </h1>
            <p class="mt-1 text-xs text-stone-500">
                Informasi ini akan tertera pada faktur resmi, pesanan, dan direktori marketplace.
            </p>
        </div>

        <!-- Skeleton Loading -->
        <div v-if="loading" class="h-80 rounded-3xl border border-stone-200/80 bg-white p-8 animate-pulse">
            <div class="h-6 w-1/3 bg-stone-100 rounded"></div>
            <div class="mt-6 space-y-4">
                <div class="h-10 bg-stone-100 rounded-xl"></div>
                <div class="h-10 bg-stone-100 rounded-xl"></div>
            </div>
        </div>

        <div v-else class="space-y-6">
            <!-- Main Profile Form Card -->
            <div class="rounded-3xl border border-stone-200/90 bg-white p-6 sm:p-8 shadow-xs">
                <!-- Notifications -->
                <p v-if="error" class="mb-5 rounded-2xl border border-red-200 bg-red-50 p-4 text-xs font-medium text-red-600">
                    {{ error }}
                </p>
                <div v-if="success" class="mb-5 flex items-center gap-2 rounded-2xl border border-emerald-200 bg-emerald-50 p-4 text-xs font-semibold text-emerald-800">
                    <span class="flex h-4 w-4 items-center justify-center rounded-full bg-emerald-600 text-[10px] text-white">✓</span>
                    <span>{{ success }}</span>
                </div>

                <form class="grid gap-4 sm:grid-cols-2" @submit.prevent="save">
                    <div>
                        <label class="label" for="company_name">
                            {{ isMerchant ? 'Nama Bisnis / Dapur Katering' : 'Nama Perusahaan / Kantor' }}
                        </label>
                        <input id="company_name" v-model="form.company_name" class="input" required />
                    </div>

                    <div>
                        <label class="label" for="name">Nama Penanggung Jawab (PIC)</label>
                        <input id="name" v-model="form.name" class="input" required />
                    </div>

                    <div>
                        <label class="label">Alamat Email (Login)</label>
                        <input class="input bg-stone-100 text-stone-500 cursor-not-allowed" :value="state.user?.email" disabled />
                    </div>

                    <div>
                        <label class="label" for="phone">Nomor Telepon / WhatsApp</label>
                        <input id="phone" v-model="form.phone" class="input" required />
                    </div>

                    <div class="sm:col-span-2">
                        <label class="label" for="address">Alamat Lengkap</label>
                        <input id="address" v-model="form.address" class="input" required />
                    </div>

                    <div :class="isMerchant ? '' : 'sm:col-span-2'">
                        <label class="label" for="city">Kota</label>
                        <input id="city" v-model="form.city" class="input" required />
                    </div>

                    <div v-if="isMerchant">
                        <label class="label" for="cuisine_type">Spesialisasi Masakan (Cuisine)</label>
                        <input id="cuisine_type" v-model="form.cuisine_type" class="input" placeholder="e.g. Nusantara, Healthy, Bento" required />
                    </div>

                    <div class="sm:col-span-2">
                        <label class="label" for="description">Deskripsi Singkat</label>
                        <textarea
                            id="description"
                            v-model="form.description"
                            class="input min-h-28 leading-relaxed"
                            rows="4"
                            :placeholder="isMerchant ? 'Ceritakan keunggulan dapur Anda, higienitas, dan jenis paket yang disajikan...' : 'Catatan profil kantor atau preferensi pengiriman...'"
                        ></textarea>
                    </div>

                    <div class="sm:col-span-2 mt-2 pt-2 border-t border-stone-100 flex items-center justify-end">
                        <button type="submit" class="btn-primary rounded-full px-7 py-2.5 text-xs uppercase tracking-wider font-bold shadow-xs" :disabled="saving">
                            {{ saving ? 'Menyimpan...' : 'Simpan Perubahan' }}
                        </button>
                    </div>
                </form>
            </div>

            <!-- Danger Zone: Delete Account Feature -->
            <div class="rounded-3xl border border-red-200 bg-red-50/40 p-6 sm:p-8">
                <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                    <div>
                        <div class="flex items-center gap-2">
                            <span class="flex h-6 w-6 items-center justify-center rounded-lg bg-red-100 text-red-700 text-xs font-bold">
                                ⚠
                            </span>
                            <h3 class="font-display text-base font-bold text-red-950">
                                Zona Berbahaya · Hapus Akun
                            </h3>
                        </div>
                        <p class="mt-1.5 text-xs text-stone-600 max-w-xl leading-relaxed">
                            <template v-if="isMerchant">
                                Menghapus akun katering akan menghapus profil dapur, seluruh menu makanan, dan riwayat pesanan secara permanen dari GoCatering.
                            </template>
                            <template v-else>
                                Menghapus akun kantor akan menghapus data perusahaan, keranjang pesanan, dan seluruh data faktur invoice secara permanen.
                            </template>
                        </p>
                    </div>

                    <button
                        type="button"
                        class="inline-flex items-center justify-center gap-2 rounded-full border border-red-300 bg-white px-5 py-2.5 text-xs font-bold text-red-700 shadow-2xs hover:bg-red-600 hover:text-white hover:border-red-600 transition active:scale-95 shrink-0 disabled:opacity-50"
                        :disabled="deleting"
                        @click="deleteAccount"
                    >
                        <svg v-if="!deleting" class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M3 6h18"></path>
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            <line x1="10" y1="11" x2="10" y2="17"></line>
                            <line x1="14" y1="11" x2="14" y2="17"></line>
                        </svg>
                        <svg v-else class="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
                        </svg>
                        <span>{{ deleting ? 'Menghapus Akun...' : 'Hapus Akun Saya' }}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
