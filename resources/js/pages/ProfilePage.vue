<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { api } from '../lib/api';
import { useAuth } from '../stores/auth';

const { state, isMerchant, setUser } = useAuth();

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
const error = ref('');
const success = ref('');

const roleLabel = computed(() => (isMerchant.value ? 'Caterer account' : 'Office account'));

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
        success.value = 'Profile updated.';
    } catch (err) {
        error.value = err.message;
    } finally {
        saving.value = false;
    }
}
</script>

<template>
    <div class="mx-auto max-w-3xl px-5 py-12">
        <div class="mb-7">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">{{ roleLabel }}</p>
            <h1 class="mt-2 font-display text-3xl text-ink-900">Profile settings</h1>
            <p class="mt-2 text-sm text-ink-500">
                This information appears on invoices and in the marketplace.
            </p>
        </div>

        <div v-if="loading" class="card p-8 text-sm text-ink-500">Loading profile...</div>

        <div v-else class="card p-6 sm:p-8">
            <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                {{ error }}
            </p>
            <p v-if="success" class="mb-5 rounded-xl border border-leaf-200 bg-leaf-50 px-4 py-3 text-sm text-leaf-700">
                {{ success }}
            </p>

            <form class="grid gap-4 sm:grid-cols-2" @submit.prevent="save">
                <div>
                    <label class="label" for="company_name">Company name</label>
                    <input id="company_name" v-model="form.company_name" class="input" required />
                </div>
                <div>
                    <label class="label" for="name">Contact person</label>
                    <input id="name" v-model="form.name" class="input" required />
                </div>
                <div>
                    <label class="label">Email</label>
                    <input class="input bg-cream-100" :value="state.user.email" disabled />
                </div>
                <div>
                    <label class="label" for="phone">Phone</label>
                    <input id="phone" v-model="form.phone" class="input" required />
                </div>
                <div class="sm:col-span-2">
                    <label class="label" for="address">Address</label>
                    <input id="address" v-model="form.address" class="input" required />
                </div>
                <div>
                    <label class="label" for="city">City</label>
                    <input id="city" v-model="form.city" class="input" required />
                </div>
                <div v-if="isMerchant">
                    <label class="label" for="cuisine_type">Cuisine type</label>
                    <input id="cuisine_type" v-model="form.cuisine_type" class="input" required />
                </div>
                <div class="sm:col-span-2">
                    <label class="label" for="description">Description</label>
                    <textarea id="description" v-model="form.description" class="input min-h-28" rows="4"></textarea>
                </div>
                <div class="sm:col-span-2">
                    <button type="submit" class="btn-primary" :disabled="saving">
                        {{ saving ? 'Saving...' : 'Save changes' }}
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>
