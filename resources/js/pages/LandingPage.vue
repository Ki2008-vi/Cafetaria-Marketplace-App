<script setup>
import { onMounted, ref } from 'vue';
import { RouterLink } from 'vue-router';
import { api } from '../lib/api';
import { money } from '../lib/format';

const caterers = ref([]);
const search = ref('');
const loading = ref(true);
const error = ref('');

const popularDishes = [
    {
        id: 1,
        name: 'Nasi Rendang Komplit',
        caterer: 'Dapur Nusantara',
        cuisine: 'Indonesian',
        calories: '650 kkal',
        portion: 'Porsi 4–6 orang',
        price: 45000,
        img: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80',
        featured: false,
    },
    {
        id: 2,
        name: 'Chicken Quinoa Bowl',
        caterer: 'Green Bowl Kitchen',
        cuisine: 'Healthy',
        calories: '480 kkal',
        portion: 'Porsi 4 orang',
        price: 55000,
        img: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=400&q=80',
        featured: true, // Spotlight card from Image 2
    },
    {
        id: 3,
        name: 'Ayam Bakar Sambal Matah',
        caterer: 'Dapur Nusantara',
        cuisine: 'Indonesian',
        calories: '520 kkal',
        portion: 'Porsi 4–6 orang',
        price: 42000,
        img: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=400&q=80',
        featured: false,
    },
    {
        id: 4,
        name: 'Vegan Buddha Salad',
        caterer: 'Green Bowl Kitchen',
        cuisine: 'Plant-Based',
        calories: '390 kkal',
        portion: 'Porsi 4 orang',
        price: 48000,
        img: 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=400&q=80',
        featured: false,
    },
];

async function load() {
    loading.value = true;
    error.value = '';

    try {
        const params = new URLSearchParams();

        if (search.value.trim()) {
            params.set('search', search.value.trim());
        }

        const suffix = params.toString() ? `?${params.toString()}` : '';
        caterers.value = await api.get(`/caterers${suffix}`);
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}

async function onSearch() {
    await load();
    setTimeout(() => {
        const el = document.getElementById('mitra-katering');
        if (el) {
            el.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }, 60);
}

async function filterCategory(cat) {
    search.value = cat;
    await onSearch();
}

async function clearSearch() {
    search.value = '';
    await load();
}

onMounted(load);
</script>

<template>
    <div class="min-h-screen bg-[#FAF7F2] text-stone-900 antialiased selection:bg-amber-300 selection:text-stone-900">
        <!-- Hero Section (GoFoddie Inspired with Warm Glow & Orbital Visuals) -->
        <section class="relative overflow-hidden border-b border-stone-200/80 bg-gradient-to-b from-amber-50/40 via-[#FAF7F2] to-[#FAF7F2] min-h-[calc(100dvh-73px)] flex flex-col justify-center py-10 lg:py-14">
            <!-- Decorative Subtle Ambient Glows -->
            <div class="pointer-events-none absolute left-1/2 top-0 -translate-x-1/2 h-[550px] w-[900px] rounded-full bg-gradient-to-b from-amber-200/30 to-transparent blur-3xl"></div>
            
            <div class="relative mx-auto max-w-6xl px-5 w-full flex-1 flex flex-col justify-between my-auto">
                <div class="grid items-center gap-12 lg:grid-cols-12 my-auto py-6">
                    <!-- Left Hero Content -->
                    <div class="lg:col-span-7">
                        <div class="inline-flex items-center gap-2 rounded-full border border-amber-200/80 bg-amber-50/90 px-3.5 py-1 text-xs font-semibold text-amber-800 shadow-2xs">
                            <span>B2B Catering Marketplace Terpercaya</span>
                        </div>

                        <h1 class="mt-4 sm:mt-5 font-display text-3xl font-extrabold tracking-tight text-stone-900 sm:text-5xl lg:text-6xl lg:leading-[1.12]">
                            Makan Siang Tim Jadi
                            <span class="relative inline-block text-amber-600">
                                Lebih Berselera
                                <svg class="absolute -bottom-1 left-0 w-full text-amber-300/70" viewBox="0 0 100 12" fill="none" preserveAspectRatio="none">
                                    <path d="M0 8C30 1 70 1 100 8" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                                </svg>
                            </span>
                            & Praktis.
                        </h1>

                        <p class="mt-4 sm:mt-5 max-w-xl text-sm leading-relaxed text-stone-600 sm:text-lg">
                            Pesan katering harian, meeting lunch, dan event kantor dari mitra dapur terverifikasi. Tentukan porsi tim dan satukan semua tagihan ke <strong>1 invoice terpadu</strong>.
                        </p>

                        <!-- Search Bar (Responsive Pill Style) -->
                        <form class="mt-6 sm:mt-8 flex max-w-xl items-center rounded-full border border-stone-300/90 bg-white p-1.5 sm:p-2 shadow-sm transition focus-within:border-stone-900 focus-within:ring-4 focus-within:ring-stone-200/60" @submit.prevent="onSearch">
                            <div class="flex flex-1 items-center gap-2 sm:gap-3 pl-2 sm:pl-3 min-w-0">
                                <svg class="h-4 w-4 sm:h-5 sm:w-5 text-stone-400 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input
                                    v-model="search"
                                    type="search"
                                    placeholder="Cari katering, menu..."
                                    class="w-full bg-transparent text-xs sm:text-sm text-stone-900 placeholder-stone-400 focus:outline-none min-w-0"
                                />
                                <button
                                    v-if="search"
                                    type="button"
                                    @click="clearSearch"
                                    class="px-1.5 text-xs font-bold text-stone-400 hover:text-stone-800 transition shrink-0"
                                    title="Hapus filter"
                                >
                                    ✕
                                </button>
                            </div>
                            <button
                                type="submit"
                                class="btn-primary rounded-full px-4 sm:px-6 py-2.5 sm:py-3 text-xs uppercase tracking-wider font-bold transition shrink-0 disabled:opacity-75"
                                :disabled="loading"
                            >
                                <span v-if="loading" class="flex items-center gap-1.5">
                                    <svg class="h-3.5 w-3.5 animate-spin" viewBox="0 0 24 24" fill="none">
                                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
                                    </svg>
                                    <span class="hidden sm:inline">Mencari...</span>
                                </span>
                                <span v-else>
                                    <span>Cari</span><span class="hidden sm:inline"> Katering</span>
                                </span>
                            </button>
                        </form>

                        <!-- Quick Category Pills -->
                        <div class="mt-4 flex flex-wrap items-center gap-1.5 sm:gap-2 text-xs text-stone-500">
                            <span class="font-medium text-stone-400 text-[11px] sm:text-xs">Populer:</span>
                            <button type="button" @click="filterCategory('Nusantara')" class="rounded-full border border-stone-200 bg-white px-2.5 sm:px-3 py-1 hover:border-amber-400 hover:text-amber-800 transition text-[11px] sm:text-xs">
                                🍛 Nusantara
                            </button>
                            <button type="button" @click="filterCategory('Healthy')" class="rounded-full border border-stone-200 bg-white px-2.5 sm:px-3 py-1 hover:border-amber-400 hover:text-amber-800 transition text-[11px] sm:text-xs">
                                🥗 Healthy Bowls
                            </button>
                            <button type="button" @click="filterCategory('Bento')" class="rounded-full border border-stone-200 bg-white px-2.5 sm:px-3 py-1 hover:border-amber-400 hover:text-amber-800 transition text-[11px] sm:text-xs">
                                🍱 Bento
                            </button>
                            <button type="button" @click="filterCategory('Snack')" class="rounded-full border border-stone-200 bg-white px-2.5 sm:px-3 py-1 hover:border-amber-400 hover:text-amber-800 transition text-[11px] sm:text-xs">
                                🥐 Snack
                            </button>
                        </div>

                        <!-- Social Proof Avatars Stack -->
                        <div class="mt-6 sm:mt-8 flex items-center gap-3 sm:gap-4 border-t border-stone-200/60 pt-5 sm:pt-6">
                            <div class="flex -space-x-2 overflow-hidden shrink-0">
                                <img class="inline-block h-8 w-8 sm:h-9 sm:w-9 rounded-full ring-2 ring-white object-cover" src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=80&q=80" alt="Customer" />
                                <img class="inline-block h-8 w-8 sm:h-9 sm:w-9 rounded-full ring-2 ring-white object-cover" src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=80&q=80" alt="Customer" />
                                <img class="inline-block h-8 w-8 sm:h-9 sm:w-9 rounded-full ring-2 ring-white object-cover" src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=80&q=80" alt="Customer" />
                                <img class="inline-block h-8 w-8 sm:h-9 sm:w-9 rounded-full ring-2 ring-white object-cover" src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=80&q=80" alt="Customer" />
                            </div>
                            <div class="text-[11px] sm:text-xs">
                                <div class="flex items-center gap-1 font-bold text-stone-900">
                                    <span class="text-amber-500">★★★★★</span>
                                    <span>4.9 / 5.0</span>
                                </div>
                                <p class="text-stone-500">Dipercaya oleh <strong>350+ tim kantor</strong></p>
                            </div>
                        </div>
                    </div>

                    <!-- Right Hero Visual (Responsive Orbital Feature) -->
                    <div class="relative flex items-center justify-center lg:col-span-5 py-4 sm:py-6 overflow-visible w-full max-w-[340px] sm:max-w-none mx-auto">
                        <div class="relative flex items-center justify-center">
                            <!-- Background Concentric Rings -->
                            <div class="absolute h-64 w-64 sm:h-[380px] sm:w-[380px] lg:h-[440px] lg:w-[440px] rounded-full border border-amber-300/40 bg-amber-100/30"></div>
                            <div class="absolute h-72 w-72 sm:h-[440px] sm:w-[440px] lg:h-[500px] lg:w-[500px] rounded-full border border-stone-300/30"></div>

                            <!-- Central Appetizing Culinary Bowl -->
                            <div class="relative z-10 h-56 w-56 sm:h-76 sm:w-76 lg:h-96 lg:w-96 overflow-hidden rounded-full border-4 border-white shadow-2xl transition hover:scale-102 duration-300">
                                <img
                                    src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80"
                                    alt="Healthy Fresh Catering"
                                    class="h-full w-full object-cover"
                                />
                            </div>

                            <!-- Floating Orbital Badge 1: Delivery Time -->
                            <div class="absolute -top-3 -left-2 sm:-top-4 sm:-left-4 z-20 flex items-center gap-1.5 sm:gap-2 rounded-2xl border border-stone-200/80 bg-white/95 px-2.5 sm:px-3.5 py-1.5 sm:py-2 shadow-lg backdrop-blur">
                                <div class="flex h-7 w-7 sm:h-8 sm:w-8 items-center justify-center rounded-xl bg-amber-100 text-amber-700">
                                    <svg class="h-3.5 w-3.5 sm:h-4 sm:w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <span class="block text-[9px] sm:text-[10px] font-bold text-stone-400 uppercase tracking-wider">Tepat Waktu</span>
                                    <span class="block text-[11px] sm:text-xs font-bold text-stone-900">11:30 WIB</span>
                                </div>
                            </div>

                            <!-- Floating Orbital Badge 2: 1 Invoice -->
                            <div class="absolute -bottom-4 -right-1 sm:-bottom-6 sm:-right-2 z-20 flex items-center gap-1.5 sm:gap-2 rounded-2xl border border-stone-200/80 bg-white/95 px-2.5 sm:px-3.5 py-1.5 sm:py-2 shadow-lg backdrop-blur">
                                <div class="flex h-7 w-7 sm:h-8 sm:w-8 items-center justify-center rounded-xl bg-emerald-100 text-emerald-700">
                                    <svg class="h-3.5 w-3.5 sm:h-4 sm:w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                    </svg>
                                </div>
                                <div>
                                    <span class="block text-[9px] sm:text-[10px] font-bold text-emerald-600 uppercase tracking-wider">B2B Solved</span>
                                    <span class="block text-[11px] sm:text-xs font-bold text-stone-900">1 Invoice Bulanan</span>
                                </div>
                            </div>

                            <!-- Floating Orbital Badge 3: Halal -->
                            <div class="hidden sm:block absolute top-1/2 -right-6 z-20 -translate-y-1/2 rounded-full border border-stone-200 bg-white px-3 py-1 shadow-md text-xs font-semibold text-stone-700">
                                🌿 100% Halal
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Trusted Office Companies Monochromatic Bar -->
                <div class="mt-8 lg:mt-12 border-t border-stone-200/70 pt-6 pb-2">
                    <p class="text-center text-xs font-semibold uppercase tracking-wider text-stone-400">
                        Dipercaya oleh Office Manager di berbagai perusahaan terkemuka
                    </p>
                    <div class="mt-4 flex flex-wrap items-center justify-center gap-8 opacity-60 grayscale transition hover:grayscale-0 sm:gap-12 text-sm font-bold tracking-tight text-stone-600">
                        <span class="flex items-center gap-1.5">TOKOPEDIA</span>
                        <span class="flex items-center gap-1.5">SHOPEE</span>
                        <span class="flex items-center gap-1.5">GOTO</span>
                        <span class="flex items-center gap-1.5">TRAVELOKA</span>
                        <span class="flex items-center gap-1.5">BANK CENTRAL ASIA</span>
                        <span class="flex items-center gap-1.5">BLIBLI</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Featured Menu Items Showcase (Image 2 Bell Inspired Overlapping Plate Cards) -->
        <section class="mx-auto max-w-6xl px-5 py-20">
            <div class="text-center">
                <span class="rounded-full bg-amber-100 px-3.5 py-1 text-xs font-bold uppercase tracking-wider text-amber-800">
                    Pilihan Favorit Tim
                </span>
                <h2 class="mt-3 font-display text-3xl font-bold tracking-tight text-stone-900 sm:text-4xl">
                    Menu Terlaris Minggu Ini
                </h2>
                <p class="mx-auto mt-2 max-w-lg text-sm text-stone-500">
                    Pilihan menu makan siang porsi tim kantor yang paling banyak dipesan minggu ini.
                </p>
            </div>

            <!-- Bell-style Cards Grid with Overlapping Plates -->
            <div class="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
                <div
                    v-for="dish in popularDishes"
                    :key="dish.id"
                    class="group relative flex flex-col justify-between pt-14"
                >
                    <!-- Overlapping Floating Circular Food Plate -->
                    <div class="absolute left-1/2 top-0 -translate-x-1/2 z-20 h-28 w-28 overflow-hidden rounded-full border-4 border-white shadow-xl transition-transform duration-300 group-hover:scale-108 group-hover:-translate-y-1">
                        <img :src="dish.img" :alt="dish.name" class="h-full w-full object-cover" />
                    </div>

                    <!-- Card Body -->
                    <div
                        class="flex flex-1 flex-col justify-between rounded-3xl p-6 pt-18 shadow-sm transition-all duration-200 group-hover:shadow-lg"
                        :class="dish.featured ? 'bg-amber-400 text-stone-950 border border-amber-300' : 'bg-white text-stone-900 border border-stone-200/80'"
                    >
                        <div>
                            <div class="flex items-center justify-between gap-1 text-[11px] font-semibold">
                                <span :class="dish.featured ? 'text-stone-900 font-bold' : 'text-stone-400'">
                                    {{ dish.caterer }}
                                </span>
                                <span :class="dish.featured ? 'bg-amber-500/80 text-stone-950 px-2 py-0.5 rounded-full' : 'text-stone-400'">
                                    {{ dish.calories }}
                                </span>
                            </div>

                            <h3 class="mt-3 font-display text-base font-bold leading-snug line-clamp-2">
                                {{ dish.name }}
                            </h3>

                            <p class="mt-1 text-xs" :class="dish.featured ? 'text-stone-800' : 'text-stone-500'">
                                {{ dish.portion }}
                            </p>
                        </div>

                        <!-- Card Footer: Price & Add Button -->
                        <div class="mt-6 flex items-center justify-between border-t pt-4" :class="dish.featured ? 'border-amber-500/60' : 'border-stone-100'">
                            <div>
                                <span class="block text-[10px] uppercase font-bold" :class="dish.featured ? 'text-stone-800' : 'text-stone-400'">
                                    Harga
                                </span>
                                <span class="font-display text-sm font-extrabold" :class="dish.featured ? 'text-stone-950' : 'text-stone-900'">
                                    {{ money(dish.price) }}
                                </span>
                            </div>

                            <RouterLink
                                to="/office"
                                class="flex h-9 w-9 items-center justify-center rounded-xl shadow-xs transition hover:scale-105 active:scale-95"
                                :class="dish.featured ? 'bg-stone-950 text-amber-300' : 'bg-amber-500 text-stone-950'"
                                title="Pesan menu ini"
                            >
                                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                            </RouterLink>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Catalog List Section: Verified Caterer Partners -->
        <section id="mitra-katering" class="scroll-mt-16 border-t border-stone-200/80 bg-[#FAF7F2] py-16">
            <div class="mx-auto max-w-6xl px-5">
                <div class="mb-8 flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between border-b border-stone-200/60 pb-5">
                    <div>
                        <div class="flex items-center gap-2">
                            
                            <span v-if="search" class="inline-flex items-center gap-1.5 rounded-full border border-amber-300 bg-amber-50 px-3 py-0.5 text-xs font-semibold text-amber-900">
                                <span>Hasil: "{{ search }}" ({{ caterers.length }})</span>
                                <button type="button" @click="clearSearch" class="font-bold hover:text-stone-950 ml-1">✕</button>
                            </span>
                        </div>
                        <h2 class="mt-2 font-display text-2xl font-bold text-stone-900 sm:text-3xl">
                            Mitra Vendor Katering
                        </h2>
                        <p class="mt-1 text-xs text-stone-500">
                            Pilihan vendor katering siap melayani kebutuhan makan siang harian dan event kantor
                        </p>
                    </div>

                    <div class="flex items-center gap-3">
                        <button
                            v-if="search"
                            type="button"
                            @click="clearSearch"
                            class="text-xs font-bold text-stone-500 hover:text-stone-900 underline"
                        >
                            Tampilkan Semua
                        </button>
                        <RouterLink to="/office" class="inline-flex items-center gap-1.5 text-xs font-bold text-amber-600 hover:text-amber-700">
                            <span>Buka Katalog Lengkap</span>
                            <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </RouterLink>
                    </div>
                </div>

                <!-- Error State -->
                <p v-if="error" class="mb-6 rounded-2xl border border-red-200 bg-red-50 p-4 text-xs text-red-600">
                    {{ error }}
                </p>

                <!-- Loading Skeleton -->
                <div v-if="loading" class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                    <div v-for="n in 3" :key="n" class="h-64 rounded-3xl border border-stone-200/80 bg-white p-6 animate-pulse">
                        <div class="h-5 w-1/3 bg-stone-100 rounded-lg"></div>
                        <div class="mt-4 h-6 w-2/3 bg-stone-100 rounded-lg"></div>
                        <div class="mt-3 h-16 w-full bg-stone-100 rounded-xl"></div>
                    </div>
                </div>

                <!-- Empty State -->
                <div v-else-if="!caterers.length" class="rounded-3xl border border-dashed border-stone-200 bg-white p-12 text-center text-sm text-stone-500">
                    <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-2xl bg-amber-50 text-2xl">
                        🔍
                    </div>
                    <p class="mt-4 font-display text-lg font-bold text-stone-800">
                        Tidak ada katering ditemukan<span v-if="search"> untuk "{{ search }}"</span>
                    </p>
                    <p class="mt-1 text-xs text-stone-400">Coba gunakan kata kunci lain seperti "Nusantara", "Healthy", atau "Padang".</p>
                    <button
                        type="button"
                        class="btn-primary mt-5 rounded-full px-5 py-2.5 text-xs font-bold"
                        @click="clearSearch"
                    >
                        Tampilkan Semua Mitra Katering
                    </button>
                </div>

                <!-- Caterer Cards Grid -->
                <div v-else class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                    <article
                        v-for="caterer in caterers"
                        :key="caterer.id"
                        class="group flex flex-col justify-between rounded-3xl border border-stone-200/90 bg-white p-6 shadow-xs transition duration-200 hover:-translate-y-1 hover:border-amber-300 hover:shadow-lg"
                    >
                        <div>
                            <!-- Header Info -->
                            <div class="flex items-center justify-between gap-2">
                                <span class="rounded-full bg-amber-50 border border-amber-200/80 px-3 py-0.5 text-[11px] font-bold text-amber-800 uppercase tracking-wide">
                                    {{ caterer.cuisine_type || 'Katering' }}
                                </span>
                                <span class="flex items-center gap-1 text-xs text-stone-400">
                                    <svg class="h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                        <circle cx="12" cy="10" r="3"></circle>
                                    </svg>
                                    {{ caterer.city || 'Indonesia' }}
                                </span>
                            </div>

                            <h3 class="mt-4 font-display text-xl font-bold text-stone-900 group-hover:text-amber-700 transition">
                                {{ caterer.company_name }}
                            </h3>

                            <p class="mt-2 line-clamp-3 text-xs leading-relaxed text-stone-500">
                                {{ caterer.description || 'Menyediakan aneka paket makan siang harian dan event kantor higienis dengan bahan segar pilihan.' }}
                            </p>
                        </div>

                        <!-- Card Footer -->
                        <div class="mt-6 border-t border-stone-100 pt-4 flex items-center justify-between">
                            <div class="flex flex-col">
                                <span class="text-[11px] font-medium text-stone-400">{{ caterer.menu_count }} menu tersedia</span>
                                <span class="text-xs font-bold text-stone-800">
                                    <template v-if="caterer.min_price !== null">
                                        Mulai {{ money(caterer.min_price) }}
                                    </template>
                                    <template v-else>Harga fleksibel</template>
                                </span>
                            </div>

                            <RouterLink
                                :to="{ name: 'caterer.show', params: { id: caterer.id } }"
                                class="inline-flex items-center gap-1.5 rounded-full bg-stone-900 px-4 py-2 text-xs font-bold text-white shadow-xs transition hover:bg-stone-800 group-hover:bg-amber-500 group-hover:text-stone-950"
                            >
                                <span>Lihat Menu</span>
                                <svg class="h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </RouterLink>
                        </div>
                    </article>
                </div>
            </div>
        </section>

        <!-- 3 Simple Steps for Office Managers -->
        <section class="border-t border-stone-200/80 bg-[#FAF7F2] py-20">
            <div class="mx-auto max-w-5xl px-5 text-center">
                <span class="rounded-full bg-stone-200/80 px-3.5 py-1 text-xs font-bold uppercase tracking-wider text-stone-700">
                    Cara Kerja
                </span>
                <h2 class="mt-3 font-display text-3xl font-bold tracking-tight text-stone-900 sm:text-4xl">
                    Katering Kantor Tanpa Ribet
                </h2>
                <p class="mx-auto mt-2 max-w-lg text-sm text-stone-500">
                    Tinggalkan proses manual dengan WhatsApp dan invoice tercecer. 3 langkah mudah untuk tim Anda.
                </p>

                <div class="mt-14 grid gap-8 sm:grid-cols-3 text-left">
                    <div class="rounded-3xl border border-stone-200/90 bg-white p-7 shadow-xs">
                        <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-amber-100 text-amber-700 font-display text-lg font-black">
                            01
                        </div>
                        <h3 class="mt-5 font-display text-lg font-bold text-stone-900">Pilih Dapur & Menu</h3>
                        <p class="mt-2 text-xs leading-relaxed text-stone-500">
                            Jelajahi puluhan vendor katering terkurasi dengan menu yang bisa disesuaikan selera tim atau pantangan diet.
                        </p>
                    </div>

                    <div class="rounded-3xl border border-stone-200/90 bg-white p-7 shadow-xs">
                        <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-emerald-100 text-emerald-700 font-display text-lg font-black">
                            02
                        </div>
                        <h3 class="mt-5 font-display text-lg font-bold text-stone-900">Atur Porsi & Jadwal</h3>
                        <p class="mt-2 text-xs leading-relaxed text-stone-500">
                            Tentukan tanggal dan jam antar (misal setiap 11:30 WIB) serta jumlah porsi secara presisi.
                        </p>
                    </div>

                    <div class="rounded-3xl border border-stone-200/90 bg-white p-7 shadow-xs">
                        <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-stone-900 text-amber-400 font-display text-lg font-black">
                            03
                        </div>
                        <h3 class="mt-5 font-display text-lg font-bold text-stone-900">1 Invoice Konsolidasi</h3>
                        <p class="mt-2 text-xs leading-relaxed text-stone-500">
                            Finance tidak perlu pusing. Semua pesanan selama sebulan terkumpul dalam satu faktur resmi perusahaan.
                        </p>
                    </div>
                </div>

                <!-- Call to action card -->
                <div class="mt-14 rounded-3xl bg-stone-900 p-8 sm:p-12 text-center text-white relative overflow-hidden">
                    <div class="relative z-10 mx-auto max-w-xl">
                        <h3 class="font-display text-2xl font-bold sm:text-3xl">
                            Siap Tingkatkan Kualitas Makan Siang Kantor Anda?
                        </h3>
                        <p class="mt-3 text-xs leading-relaxed text-stone-400 sm:text-sm">
                            Daftarkan kantor Anda sekarang atau hubungi tim kami untuk konsultasi paket berlangganan makan siang tim.
                        </p>
                        <div class="mt-6 flex flex-wrap justify-center gap-3">
                            <RouterLink to="/register" class="btn-accent rounded-full px-6 py-3 text-xs uppercase tracking-wider font-bold">
                                Daftar Akun Kantor Sekarang
                            </RouterLink>
                            <RouterLink to="/office" class="rounded-full border border-stone-700 bg-stone-800 px-6 py-3 text-xs font-bold text-white hover:bg-stone-700 transition">
                                Jelajahi Semua Menu
                            </RouterLink>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>
