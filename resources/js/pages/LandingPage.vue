<script setup>
import { onMounted, ref } from 'vue';
import { RouterLink } from 'vue-router';
import { api } from '../lib/api';
import { money } from '../lib/format';

const caterers = ref([]);
const search = ref('');
const loading = ref(true);
const error = ref('');

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

onMounted(load);
</script>

<template>
    <div>
        <section class="relative overflow-hidden">
            <div class="pointer-events-none absolute -right-32 -top-32 h-96 w-96 rounded-full bg-leaf-100 blur-3xl"></div>
            <div class="pointer-events-none absolute -bottom-40 -left-24 h-96 w-96 rounded-full bg-ember-100 blur-3xl"></div>

            <div class="relative mx-auto grid max-w-6xl items-center gap-12 px-5 py-16 lg:grid-cols-[1.1fr_0.9fr] lg:py-24">
                <div>
                    <p class="mb-4 inline-flex items-center rounded-full border border-leaf-200 bg-leaf-50 px-3 py-1 text-xs font-bold uppercase tracking-[0.18em] text-leaf-700">
                        Fresh office lunches
                    </p>
                    <h1 class="max-w-2xl font-display text-4xl leading-[1.08] text-ink-900 sm:text-5xl lg:text-6xl">
                        Feed your team without the daily lunch scramble.
                    </h1>
                    <p class="mt-5 max-w-xl text-base leading-relaxed text-ink-500">
                        Discover trusted local caterers, order lunch by the portion, and keep every invoice in one place.
                        Built for offices that want good food and a simple process.
                    </p>

                    <form class="mt-8 flex max-w-xl flex-col gap-2 sm:flex-row" @submit.prevent="load">
                        <input
                            v-model="search"
                            class="input"
                            type="search"
                            placeholder="Search caterers, cuisine, or a dish..."
                        />
                        <button type="submit" class="btn-accent shrink-0">Find lunch</button>
                    </form>

                    <div class="mt-5 flex flex-wrap items-center gap-3 text-sm text-ink-400">
                        <RouterLink to="/register" class="font-semibold text-leaf-700 hover:underline">
                            Register your office
                        </RouterLink>
                        <span class="text-ink-900/20">·</span>
                        <RouterLink to="/register" class="font-semibold text-leaf-700 hover:underline">
                            List your catering business
                        </RouterLink>
                    </div>
                </div>

                <div class="relative mx-auto w-full max-w-md">
                    <div class="card relative z-10 p-6">
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-ink-400">Today at a glance</p>
                        <div class="mt-5 space-y-4">
                            <div class="flex items-start gap-3 rounded-2xl bg-leaf-50 p-4">
                                <span class="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-leaf-700 text-white">01</span>
                                <div>
                                    <p class="font-semibold text-ink-900">Browse local caterers</p>
                                    <p class="text-sm text-ink-500">Compare menus, prices, and cuisine types.</p>
                                </div>
                            </div>
                            <div class="flex items-start gap-3 rounded-2xl bg-ember-50 p-4">
                                <span class="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-ember-500 text-white">02</span>
                                <div>
                                    <p class="font-semibold text-ink-900">Order by the portion</p>
                                    <p class="text-sm text-ink-500">Pick a delivery date and tell the caterer what you need.</p>
                                </div>
                            </div>
                            <div class="flex items-start gap-3 rounded-2xl bg-cream-100 p-4">
                                <span class="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-ink-700 text-white">03</span>
                                <div>
                                    <p class="font-semibold text-ink-900">Pay from one invoice</p>
                                    <p class="text-sm text-ink-500">Both the office and the caterer see the same invoice.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="absolute -bottom-5 -right-5 h-32 w-32 rounded-3xl border border-ember-200 bg-ember-100/70"></div>
                </div>
            </div>
        </section>

        <section class="border-t border-ink-900/5 bg-white/50">
            <div class="mx-auto max-w-6xl px-5 py-14">
                <div class="mb-8 flex flex-wrap items-end justify-between gap-4">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Featured kitchens</p>
                        <h2 class="mt-2 font-display text-3xl text-ink-900">Caterers ready to cook</h2>
                    </div>
                    <RouterLink to="/register" class="btn-secondary">Join as an office</RouterLink>
                </div>

                <p v-if="error" class="mb-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                    {{ error }}
                </p>

                <div v-if="loading" class="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
                    <div v-for="n in 3" :key="n" class="card h-64 animate-pulse bg-cream-100"></div>
                </div>

                <div v-else-if="!caterers.length" class="card p-10 text-center text-ink-500">
                    No caterers found. Try a different search.
                </div>

                <div v-else class="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
                    <article v-for="caterer in caterers" :key="caterer.id" class="card flex flex-col overflow-hidden">
                        <div class="relative h-28 bg-gradient-to-br from-leaf-600 via-leaf-700 to-ink-900">
                            <span class="absolute bottom-3 left-5 rounded-full bg-white/15 px-3 py-1 text-xs font-semibold text-white backdrop-blur">
                                {{ caterer.cuisine_type || 'Catering' }}
                            </span>
                        </div>
                        <div class="flex flex-1 flex-col p-5">
                            <h3 class="font-display text-xl text-ink-900">{{ caterer.company_name }}</h3>
                            <p class="mt-1 text-sm text-ink-400">{{ caterer.city }}</p>
                            <p class="mt-3 line-clamp-3 flex-1 text-sm leading-relaxed text-ink-500">
                                {{ caterer.description || 'Fresh catering for offices and teams.' }}
                            </p>
                            <div class="mt-5 flex items-center justify-between gap-3">
                                <span class="text-sm text-ink-500">
                                    {{ caterer.menu_count }} dishes
                                    <template v-if="caterer.min_price !== null">
                                        · from {{ money(caterer.min_price) }}
                                    </template>
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
        </section>
    </div>
</template>
