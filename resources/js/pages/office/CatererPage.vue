<script setup>
import { onMounted, reactive, ref } from 'vue';
import { RouterLink, useRoute } from 'vue-router';
import { api } from '../../lib/api';
import { money } from '../../lib/format';
import { useAuth } from '../../stores/auth';
import { useCart } from '../../stores/cart';
import { useConfirm } from '../../stores/confirm';

const route = useRoute();
const { isOffice } = useAuth();
const cart = useCart();
const { ask } = useConfirm();

const caterer = ref(null);
const loading = ref(true);
const error = ref('');
const message = ref('');
const quantities = reactive({});

async function load() {
    loading.value = true;
    error.value = '';

    try {
        caterer.value = await api.get(`/caterers/${route.params.id}`);
        caterer.value.menu_items.forEach((item) => {
            quantities[item.id] = 1;
        });
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}

function adjustQty(itemId, delta) {
    const current = Number(quantities[itemId]) || 1;
    quantities[itemId] = Math.max(1, current + delta);
}

async function add(item) {
    const quantity = Math.max(1, Number(quantities[item.id]) || 1);

    if (cart.hasDifferentCaterer(caterer.value.id)) {
        const confirmed = await ask({
            title: 'Ganti Pilihan Katering?',
            message: `Keranjang Anda saat ini berisi menu dari katering lain. Apakah Anda ingin mengosongkan keranjang sebelumnya dan beralih ke "${caterer.value.company_name}"?`,
            confirmText: 'Ya, Ganti Keranjang',
            cancelText: 'Batalkan',
            type: 'warning',
        });

        if (!confirmed) {
            return;
        }
    }

    cart.add(caterer.value, item, quantity);
    message.value = `${quantity} × ${item.name} berhasil ditambahkan ke keranjang.`;
    setTimeout(() => {
        if (message.value.includes(item.name)) {
            message.value = '';
        }
    }, 4500);
}

onMounted(load);
</script>

<template>
    <div class="mx-auto max-w-6xl px-5 py-10">
        <!-- Back Navigation -->
        <div class="mb-6">
            <RouterLink to="/office" class="inline-flex items-center gap-2 rounded-full border border-stone-200 bg-white px-4 py-2 text-xs font-semibold text-stone-600 hover:text-stone-900 hover:border-stone-300 transition shadow-2xs">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                <span>Kembali ke Katalog Katering</span>
            </RouterLink>
        </div>

        <!-- Error Notification -->
        <p v-if="error" class="mb-6 rounded-2xl border border-red-200 bg-red-50 p-4 text-xs text-red-600">
            {{ error }}
        </p>

        <!-- Skeleton Loading -->
        <div v-if="loading" class="h-64 rounded-3xl border border-stone-200/80 bg-white p-8 animate-pulse">
            <div class="h-6 w-1/4 bg-stone-100 rounded"></div>
            <div class="mt-4 h-10 w-1/2 bg-stone-100 rounded"></div>
        </div>

        <template v-else-if="caterer">
            <!-- Caterer Profile Header Card (Warm Ambient Style) -->
            <header class="overflow-hidden rounded-3xl border border-stone-200/90 bg-white shadow-xs">
                <div class="relative bg-gradient-to-r from-amber-500/20 via-amber-100/30 to-emerald-50/40 p-6 sm:p-10 border-b border-stone-100">
                    <div class="flex flex-wrap items-start justify-between gap-4">
                        <div>
                            <div class="flex items-center gap-2">
                                <span class="rounded-full bg-amber-500 px-3 py-1 text-xs font-bold text-stone-950 uppercase tracking-wider">
                                    {{ caterer.cuisine_type || 'Spesialis Katering' }}
                                </span>
                                <span class="rounded-full bg-emerald-100 border border-emerald-200 px-3 py-1 text-xs font-semibold text-emerald-800">
                                    ✓ Mitra Terverifikasi
                                </span>
                            </div>

                            <h1 class="mt-4 font-display text-3xl font-extrabold tracking-tight text-stone-900 sm:text-4xl">
                                {{ caterer.company_name }}
                            </h1>

                            <div class="mt-3 flex flex-wrap items-center gap-4 text-xs text-stone-500">
                                <span class="flex items-center gap-1.5">
                                    <svg class="h-4 w-4 text-stone-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                    {{ caterer.address }}, {{ caterer.city }}
                                </span>
                                <span>·</span>
                                <span class="flex items-center gap-1.5">
                                    <svg class="h-4 w-4 text-stone-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                    </svg>
                                    {{ caterer.phone }}
                                </span>
                            </div>
                        </div>

                        <div class="rounded-2xl border border-stone-200/80 bg-white/90 p-3 px-4 text-right shadow-2xs backdrop-blur">
                            <span class="block text-[10px] font-bold uppercase tracking-wider text-stone-400">Pilihan Menu</span>
                            <span class="font-display text-2xl font-black text-stone-900">{{ caterer.menu_count }} Hidangan</span>
                        </div>
                    </div>

                    <p class="mt-5 max-w-3xl text-xs sm:text-sm leading-relaxed text-stone-600">
                        {{ caterer.description || 'Penyedia katering kantor terpercaya dengan cita rasa higienis dan porsi terukur.' }}
                    </p>
                </div>
            </header>

            <!-- Main Layout: Menu Catalog (Left) + Cart Summary (Right) -->
            <div class="mt-8 grid gap-8 lg:grid-cols-[1fr_340px]">
                <!-- Menu Catalog Column -->
                <div>
                    <div class="mb-5 flex items-center justify-between">
                        <div>
                            <h2 class="font-display text-2xl font-bold tracking-tight text-stone-900">Daftar Hidangan & Porsi</h2>
                            <p class="text-xs text-stone-500">Pilih menu dan tentukan porsi makan untuk tim Anda</p>
                        </div>
                    </div>

                    <div v-if="!caterer.menu_items.length" class="rounded-3xl border border-dashed border-stone-200 bg-white p-12 text-center text-sm text-stone-500">
                        Vendor katering ini belum memiliki menu aktif.
                    </div>

                    <!-- Menu Items List -->
                    <div v-else class="space-y-4">
                        <article
                            v-for="item in caterer.menu_items"
                            :key="item.id"
                            class="group flex flex-col gap-5 rounded-3xl border border-stone-200/90 bg-white p-5 shadow-xs transition duration-200 hover:border-amber-300 hover:shadow-md sm:flex-row sm:items-center"
                        >
                            <!-- Dish Thumbnail Image -->
                            <div class="relative shrink-0 overflow-hidden rounded-2xl h-44 sm:h-32 sm:w-32 bg-amber-50">
                                <img
                                    v-if="item.photo_url"
                                    :src="item.photo_url"
                                    :alt="item.name"
                                    class="h-full w-full object-cover transition duration-300 group-hover:scale-105"
                                />
                                <div v-else class="grid h-full w-full place-items-center text-3xl">
                                    🍱
                                </div>
                            </div>

                            <!-- Dish Details -->
                            <div class="flex flex-1 flex-col justify-between">
                                <div>
                                    <div class="flex flex-wrap items-baseline justify-between gap-2">
                                        <h3 class="font-display text-lg font-bold text-stone-900 group-hover:text-amber-700 transition">
                                            {{ item.name }}
                                        </h3>
                                        <span class="font-display text-base font-extrabold text-stone-900">
                                            {{ money(item.price) }}
                                            <span class="text-[11px] font-normal text-stone-400">/ porsi</span>
                                        </span>
                                    </div>
                                    <p class="mt-1.5 text-xs leading-relaxed text-stone-500 line-clamp-2">
                                        {{ item.description }}
                                    </p>
                                </div>

                                <!-- Ordering Controls -->
                                <div class="mt-4 flex flex-wrap items-center justify-between gap-3 border-t border-stone-100 pt-3">
                                    <template v-if="isOffice">
                                        <!-- Portion Counter Stepper -->
                                        <div class="flex items-center gap-1.5">
                                            <span class="text-[11px] font-bold uppercase tracking-wider text-stone-400 mr-1">
                                                Porsi:
                                            </span>
                                            <button
                                                type="button"
                                                @click="adjustQty(item.id, -1)"
                                                class="flex h-8 w-8 items-center justify-center rounded-xl border border-stone-200 bg-stone-50 text-stone-700 font-bold hover:bg-stone-200 transition"
                                            >
                                                −
                                            </button>
                                            <input
                                                :id="`qty-${item.id}`"
                                                v-model.number="quantities[item.id]"
                                                type="number"
                                                min="1"
                                                max="1000"
                                                class="h-8 w-14 rounded-xl border border-stone-200 text-center text-xs font-bold text-stone-900 outline-none focus:border-stone-900"
                                            />
                                            <button
                                                type="button"
                                                @click="adjustQty(item.id, 1)"
                                                class="flex h-8 w-8 items-center justify-center rounded-xl border border-stone-200 bg-stone-50 text-stone-700 font-bold hover:bg-stone-200 transition"
                                            >
                                                +
                                            </button>
                                        </div>

                                        <!-- Add Button -->
                                        <button
                                            type="button"
                                            class="inline-flex items-center gap-1.5 rounded-full bg-stone-900 px-5 py-2 text-xs font-bold text-white shadow-xs transition hover:bg-amber-500 hover:text-stone-950 active:scale-95"
                                            @click="add(item)"
                                        >
                                            <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                            </svg>
                                            <span>Tambah</span>
                                        </button>
                                    </template>

                                    <RouterLink
                                        v-else
                                        :to="{ name: 'login', query: { redirect: route.fullPath } }"
                                        class="rounded-full border border-stone-200 bg-white px-4 py-1.5 text-xs font-semibold text-stone-800 hover:bg-stone-50 transition"
                                    >
                                        Masuk sebagai akun Kantor untuk memesan
                                    </RouterLink>
                                </div>
                            </div>
                        </article>
                    </div>
                </div>

                <!-- Sticky Order Cart Summary Sidebar (Bell / GoFoddie Inspired) -->
                <aside v-if="isOffice" class="h-fit rounded-3xl border border-stone-200/90 bg-white p-6 shadow-xs lg:sticky lg:top-24">
                    <div class="flex items-center justify-between border-b border-stone-100 pb-4">
                        <div class="flex items-center gap-2">
                            <span class="flex h-8 w-8 items-center justify-center rounded-xl bg-amber-100 text-amber-800">
                                🛒
                            </span>
                            <h2 class="font-display text-lg font-bold text-stone-900">Keranjang Kantor</h2>
                        </div>
                        <span v-if="cart.count.value" class="rounded-full bg-amber-500 px-2.5 py-0.5 text-xs font-bold text-stone-950">
                            {{ cart.count.value }} porsi
                        </span>
                    </div>

                    <!-- Flash Added Toast -->
                    <div v-if="message" class="mt-4 flex items-center gap-2 rounded-2xl border border-emerald-200 bg-emerald-50 p-3 text-xs font-medium text-emerald-800">
                        <span class="flex h-4 w-4 shrink-0 items-center justify-center rounded-full bg-emerald-600 text-[10px] text-white">✓</span>
                        <span>{{ message }}</span>
                    </div>

                    <div v-if="!cart.state.items.length" class="mt-8 py-8 text-center">
                        <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-stone-100 text-xl text-stone-400">
                            🥡
                        </div>
                        <p class="mt-3 text-xs font-medium text-stone-500">Keranjang Anda masih kosong.</p>
                        <p class="mt-1 text-[11px] text-stone-400">Tambahkan hidangan untuk memulai pesanan kantor.</p>
                    </div>

                    <template v-else>
                        <p class="mt-3 text-xs font-bold text-amber-800">
                            Katering: {{ cart.state.caterer.company_name }}
                        </p>

                        <ul class="mt-4 divide-y divide-stone-100 text-xs max-h-60 overflow-y-auto pr-1">
                            <li v-for="cartItem in cart.state.items" :key="cartItem.menu_item_id" class="flex items-center justify-between py-2.5">
                                <div>
                                    <span class="font-bold text-stone-900">{{ cartItem.quantity }}x</span>
                                    <span class="ml-1.5 text-stone-700">{{ cartItem.name }}</span>
                                </div>
                                <span class="font-bold text-stone-900 shrink-0">
                                    {{ money(cartItem.price * cartItem.quantity) }}
                                </span>
                            </li>
                        </ul>

                        <div class="mt-5 border-t border-stone-200 pt-4">
                            <div class="flex items-center justify-between text-xs text-stone-500">
                                <span>Total Estimasi</span>
                                <span class="font-display text-xl font-black text-stone-900">
                                    {{ money(cart.total.value) }}
                                </span>
                            </div>
                            <p class="mt-1 text-[10px] text-stone-400">Belum termasuk PPN & ongkos kirim jika berlaku.</p>

                            <RouterLink
                                to="/office/cart"
                                class="btn-primary mt-5 flex w-full items-center justify-center gap-2 rounded-2xl py-3 text-xs uppercase tracking-wider font-bold shadow-md hover:bg-stone-800"
                            >
                                <span>Lanjut ke Checkout</span>
                                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </RouterLink>
                        </div>
                    </template>
                </aside>
            </div>
        </template>
    </div>
</template>
