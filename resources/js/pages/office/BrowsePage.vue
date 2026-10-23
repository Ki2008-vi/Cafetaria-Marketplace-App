<script setup>
import { onMounted, reactive, ref } from 'vue';
import { RouterLink, useRoute } from 'vue-router';
import { api } from '../../lib/api';
import { money } from '../../lib/format';

const route = useRoute();
const caterers = ref([]);
const filters = reactive({ cities: [], cuisines: [] });
const query = reactive({ search: '', city: '', cuisine: '' });
const loading = ref(true);
const error = ref('');

async function load() {
    loading.value = true;
    error.value = '';

    try {
        const params = new URLSearchParams();

        Object.entries(query).forEach(([key, value]) => {
            if (value) {
                params.set(key, value);
            }
        });

        const suffix = params.toString() ? `?${params.toString()}` : '';
        caterers.value = await api.get(`/caterers${suffix}`);
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}

function reset() {
    query.search = '';
    query.city = '';
    query.cuisine = '';
    load();
}

function filterByCuisine(c) {
    query.cuisine = query.cuisine === c ? '' : c;
    load();
}

onMounted(async () => {
    if (route.query.search) {
        query.search = String(route.query.search);
    }
    if (route.query.cuisine) {
        query.cuisine = String(route.query.cuisine);
    }
    if (route.query.city) {
        query.city = String(route.query.city);
    }

    try {
        const payload = await api.get('/filters');
        filters.cities = payload.cities;
        filters.cuisines = payload.cuisines;
    } catch {
        // Filters are a convenience.
    }

    await load();
});
</script>

<template>
    <div class="mx-auto max-w-6xl px-5 py-12">
        <!-- Page Title & Header -->
        <div class="mb-8">
            <span class="rounded-full bg-amber-100 px-3.5 py-1 text-xs font-bold uppercase tracking-wider text-amber-800">
                Direktori Dapur Katering
            </span>
            <h1 class="mt-3 font-display text-3xl font-extrabold tracking-tight text-stone-900 sm:text-4xl">
                Temukan Katering Terbaik untuk Kantor Anda
            </h1>
            <p class="mt-2 text-sm text-stone-600 max-w-2xl">
                Pilih katering terpercaya berdasarkan spesialisasi masakan, lokasi, dan kisaran harga. Siap melayani paket makan siang harian maupun prasmanan event.
            </p>
        </div>

        <!-- Filter & Search Bar (Modern GoFoddie Pill Shape) -->
        <form class="rounded-3xl border border-stone-200/90 bg-white p-4 shadow-sm mb-6 grid gap-3 sm:grid-cols-2 lg:grid-cols-[1.4fr_1fr_1fr_auto]" @submit.prevent="load">
            <div class="flex items-center gap-2 rounded-2xl border border-stone-200 px-3 py-2 focus-within:border-stone-900">
                <svg class="h-4 w-4 text-stone-400 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input
                    v-model="query.search"
                    class="w-full bg-transparent text-sm text-stone-900 placeholder-stone-400 focus:outline-none"
                    type="search"
                    placeholder="Cari nama katering atau menu..."
                />
            </div>

            <select v-model="query.city" class="rounded-2xl border border-stone-200 bg-white px-3 py-2 text-sm text-stone-700 outline-none focus:border-stone-900">
                <option value="">Semua Kota</option>
                <option v-for="city in filters.cities" :key="city" :value="city">{{ city }}</option>
            </select>

            <select v-model="query.cuisine" class="rounded-2xl border border-stone-200 bg-white px-3 py-2 text-sm text-stone-700 outline-none focus:border-stone-900">
                <option value="">Semua Kategori Masakan</option>
                <option v-for="cuisine in filters.cuisines" :key="cuisine" :value="cuisine">{{ cuisine }}</option>
            </select>

            <div class="flex gap-2">
                <button type="submit" class="btn-primary rounded-2xl flex-1 px-5 py-2.5 text-xs font-bold uppercase tracking-wider">
                    Filter
                </button>
                <button type="button" class="rounded-2xl border border-stone-200 px-4 py-2 text-xs font-semibold text-stone-600 hover:bg-stone-100 transition" @click="reset">
                    Reset
                </button>
            </div>
        </form>

        <!-- Fast Cuisine Chips -->
        <div v-if="filters.cuisines.length" class="mb-8 flex flex-wrap items-center gap-2 text-xs">
            <span class="text-stone-400 font-semibold mr-1">Kategori:</span>
            <button
                type="button"
                @click="reset"
                class="rounded-full px-3 py-1 font-semibold transition"
                :class="!query.cuisine ? 'bg-stone-900 text-white' : 'bg-white border border-stone-200 text-stone-600 hover:border-amber-400'"
            >
                Semua
            </button>
            <button
                v-for="c in filters.cuisines"
                :key="c"
                type="button"
                @click="filterByCuisine(c)"
                class="rounded-full px-3 py-1 font-semibold transition"
                :class="query.cuisine === c ? 'bg-amber-500 text-stone-950 font-bold' : 'bg-white border border-stone-200 text-stone-600 hover:border-amber-400'"
            >
                {{ c }}
            </button>
        </div>

        <!-- Error State -->
        <p v-if="error" class="mb-6 rounded-2xl border border-red-200 bg-red-50 p-4 text-xs text-red-600">
            {{ error }}
        </p>

        <!-- Loading Skeleton -->
        <div v-if="loading" class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            <div v-for="n in 6" :key="n" class="h-64 rounded-3xl border border-stone-200/80 bg-white p-6 animate-pulse">
                <div class="h-4 w-1/4 bg-stone-100 rounded"></div>
                <div class="mt-4 h-6 w-2/3 bg-stone-100 rounded"></div>
                <div class="mt-3 h-16 w-full bg-stone-100 rounded-xl"></div>
            </div>
        </div>

        <!-- Empty State -->
        <div v-else-if="!caterers.length" class="rounded-3xl border border-dashed border-stone-200 bg-white p-12 text-center">
            <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-50 text-2xl">
                🍲
            </div>
            <h3 class="mt-4 font-display text-xl font-bold text-stone-900">Tidak ada katering yang sesuai</h3>
            <p class="mt-1 text-xs text-stone-500">Coba ubah kata kunci atau reset filter pencarian Anda.</p>
            <button type="button" class="btn-primary mt-5 rounded-full px-5 py-2 text-xs" @click="reset">
                Reset Filter
            </button>
        </div>

        <!-- Caterers List -->
        <div v-else class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            <article
                v-for="caterer in caterers"
                :key="caterer.id"
                class="group flex flex-col justify-between rounded-3xl border border-stone-200/90 bg-white p-6 shadow-xs transition duration-200 hover:-translate-y-1 hover:border-amber-300 hover:shadow-lg"
            >
                <div>
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

                    <h2 class="mt-4 font-display text-xl font-bold text-stone-900 group-hover:text-amber-700 transition">
                        {{ caterer.company_name }}
                    </h2>

                    <p class="mt-2 line-clamp-3 text-xs leading-relaxed text-stone-500">
                        {{ caterer.description || 'Penyedia katering kantor terpercaya dengan cita rasa higienis dan porsi terukur.' }}
                    </p>
                </div>

                <div class="mt-6 border-t border-stone-100 pt-4 flex items-center justify-between">
                    <div>
                        <span class="block text-[11px] text-stone-400">{{ caterer.menu_count }} pilihan menu</span>
                        <span class="text-xs font-bold text-stone-800">
                            <template v-if="caterer.min_price !== null">
                                Mulai {{ money(caterer.min_price) }}
                            </template>
                            <template v-else>Harga fleksibel</template>
                        </span>
                    </div>

                    <RouterLink
                        :to="{ name: 'caterer.show', params: { id: caterer.id } }"
                        class="inline-flex items-center gap-1.5 rounded-full bg-stone-900 px-4 py-2 text-xs font-bold text-white shadow-xs transition group-hover:bg-amber-500 group-hover:text-stone-950"
                    >
                        <span>Buka Menu</span>
                        <svg class="h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </RouterLink>
                </div>
            </article>
        </div>
    </div>
</template>
