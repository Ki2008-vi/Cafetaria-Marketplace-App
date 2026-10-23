<script setup>
import { onMounted, reactive, ref } from 'vue';
import { RouterLink } from 'vue-router';
import { api } from '../../lib/api';
import { money } from '../../lib/format';

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

onMounted(async () => {
    try {
        const payload = await api.get('/filters');
        filters.cities = payload.cities;
        filters.cuisines = payload.cuisines;
    } catch {
        // Filters are a convenience. Browsing still works without them.
    }

    await load();
});
</script>

<template>
    <div class="mx-auto max-w-6xl px-5 py-12">
        <div class="mb-7">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Caterer directory</p>
            <h1 class="mt-2 font-display text-3xl text-ink-900">Find lunch for your office</h1>
            <p class="mt-2 text-sm text-ink-500">Search by company, cuisine, or city, then build an order by the portion.</p>
        </div>

        <form class="card mb-7 grid gap-3 p-4 sm:grid-cols-2 lg:grid-cols-[1.3fr_0.7fr_0.7fr_auto]" @submit.prevent="load">
            <input v-model="query.search" class="input" type="search" placeholder="Search caterers or cuisine..." />
            <select v-model="query.city" class="input">
                <option value="">All cities</option>
                <option v-for="city in filters.cities" :key="city" :value="city">{{ city }}</option>
            </select>
            <select v-model="query.cuisine" class="input">
                <option value="">All cuisines</option>
                <option v-for="cuisine in filters.cuisines" :key="cuisine" :value="cuisine">{{ cuisine }}</option>
            </select>
            <div class="flex gap-2">
                <button type="submit" class="btn-primary flex-1">Search</button>
                <button type="button" class="btn-ghost" @click="reset">Reset</button>
            </div>
        </form>

        <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {{ error }}
        </p>

        <div v-if="loading" class="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
            <div v-for="n in 6" :key="n" class="card h-64 animate-pulse bg-cream-100"></div>
        </div>

        <div v-else-if="!caterers.length" class="card p-10 text-center">
            <p class="font-display text-2xl text-ink-900">No caterers match those filters</p>
            <p class="mt-2 text-sm text-ink-500">Try a broader search or reset the filters.</p>
            <button type="button" class="btn-secondary mt-5" @click="reset">Reset filters</button>
        </div>

        <div v-else class="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
            <article v-for="caterer in caterers" :key="caterer.id" class="card flex flex-col overflow-hidden">
                <div class="relative h-28 bg-gradient-to-br from-leaf-600 via-leaf-700 to-ink-900">
                    <span class="absolute bottom-3 left-5 rounded-full bg-white/15 px-3 py-1 text-xs font-semibold text-white backdrop-blur">
                        {{ caterer.cuisine_type || 'Catering' }}
                    </span>
                </div>
                <div class="flex flex-1 flex-col p-5">
                    <h2 class="font-display text-xl text-ink-900">{{ caterer.company_name }}</h2>
                    <p class="mt-1 text-sm text-ink-400">{{ caterer.city }}</p>
                    <p class="mt-3 line-clamp-3 flex-1 text-sm leading-relaxed text-ink-500">
                        {{ caterer.description || 'Fresh catering for offices and teams.' }}
                    </p>
                    <div class="mt-5 flex items-center justify-between gap-3">
                        <span class="text-sm text-ink-500">
                            {{ caterer.menu_count }} dishes
                            <template v-if="caterer.min_price !== null">· from {{ money(caterer.min_price) }}</template>
                        </span>
                        <RouterLink
                            :to="{ name: 'caterer.show', params: { id: caterer.id } }"
                            class="btn-secondary"
                        >
                            View menu
                        </RouterLink>
                    </div>
                </div>
            </article>
        </div>
    </div>
</template>
