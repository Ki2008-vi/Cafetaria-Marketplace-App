<script setup>
import { onMounted, reactive, ref } from 'vue';
import { RouterLink, useRoute } from 'vue-router';
import { api } from '../../lib/api';
import { money } from '../../lib/format';
import { useAuth } from '../../stores/auth';
import { useCart } from '../../stores/cart';

const route = useRoute();
const { isOffice } = useAuth();
const cart = useCart();

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

function add(item) {
    const quantity = Math.max(1, Number(quantities[item.id]) || 1);

    if (cart.hasDifferentCaterer(caterer.value.id)) {
        const confirmed = window.confirm(
            'Your cart already contains food from another caterer. Replace that cart with this caterer?',
        );

        if (!confirmed) {
            return;
        }
    }

    cart.add(caterer.value, item, quantity);
    message.value = `${quantity} × ${item.name} added to your cart.`;
}

onMounted(load);
</script>

<template>
    <div class="mx-auto max-w-6xl px-5 py-10">
        <div class="mb-5">
            <RouterLink to="/office" class="btn-ghost">← Back to caterers</RouterLink>
        </div>

        <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {{ error }}
        </p>

        <div v-if="loading" class="card h-80 animate-pulse bg-cream-100"></div>

        <template v-else-if="caterer">
            <header class="card overflow-hidden">
                <div class="h-32 bg-gradient-to-br from-leaf-600 via-leaf-700 to-ink-900"></div>
                <div class="p-6 sm:p-8">
                    <div class="flex flex-wrap items-start justify-between gap-4">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">
                                {{ caterer.cuisine_type || 'Catering' }}
                            </p>
                            <h1 class="mt-2 font-display text-3xl text-ink-900">{{ caterer.company_name }}</h1>
                            <p class="mt-2 text-sm text-ink-500">
                                {{ caterer.address }}, {{ caterer.city }} · {{ caterer.phone }}
                            </p>
                        </div>
                        <span class="badge-green">{{ caterer.menu_count }} dishes available</span>
                    </div>
                    <p class="mt-4 max-w-3xl text-sm leading-relaxed text-ink-500">
                        {{ caterer.description || 'Fresh catering for offices and teams.' }}
                    </p>
                </div>
            </header>

            <div class="mt-8 grid gap-6 lg:grid-cols-[1fr_320px]">
                <div>
                    <h2 class="mb-4 font-display text-2xl text-ink-900">Menu</h2>

                    <div v-if="!caterer.menu_items.length" class="card p-8 text-center text-sm text-ink-500">
                        This caterer has no available dishes right now.
                    </div>

                    <div v-else class="space-y-4">
                        <article v-for="item in caterer.menu_items" :key="item.id" class="card flex flex-col gap-4 p-4 sm:flex-row">
                            <img
                                v-if="item.photo_url"
                                :src="item.photo_url"
                                :alt="item.name"
                                class="h-40 w-full rounded-2xl object-cover sm:h-28 sm:w-28"
                            />
                            <div v-else class="grid h-40 w-full place-items-center rounded-2xl bg-leaf-100 text-3xl sm:h-28 sm:w-28">🍽️</div>

                            <div class="flex flex-1 flex-col">
                                <div class="flex flex-wrap items-start justify-between gap-2">
                                    <div>
                                        <h3 class="font-semibold text-ink-900">{{ item.name }}</h3>
                                        <p class="mt-1 text-sm font-semibold text-leaf-700">{{ money(item.price) }}</p>
                                    </div>
                                </div>
                                <p class="mt-2 flex-1 text-sm leading-relaxed text-ink-500">{{ item.description }}</p>

                                <div v-if="isOffice" class="mt-3 flex flex-wrap items-center gap-2">
                                    <label class="text-xs font-semibold uppercase tracking-wider text-ink-400" :for="`qty-${item.id}`">
                                        Portions
                                    </label>
                                    <input
                                        :id="`qty-${item.id}`"
                                        v-model.number="quantities[item.id]"
                                        class="input w-20 py-1.5"
                                        type="number"
                                        min="1"
                                        max="1000"
                                    />
                                    <button type="button" class="btn-primary" @click="add(item)">Add to cart</button>
                                </div>

                                <RouterLink
                                    v-else
                                    :to="{ name: 'login', query: { redirect: route.fullPath } }"
                                    class="btn-secondary mt-3 w-fit"
                                >
                                    Log in as an office to order
                                </RouterLink>
                            </div>
                        </article>
                    </div>
                </div>

                <aside v-if="isOffice" class="card h-fit p-5 lg:sticky lg:top-24">
                    <h2 class="font-display text-xl text-ink-900">Your cart</h2>

                    <p v-if="message" class="mt-3 rounded-xl border border-leaf-200 bg-leaf-50 px-3 py-2 text-xs text-leaf-700">
                        {{ message }}
                    </p>

                    <p v-if="!cart.state.items.length" class="mt-4 text-sm text-ink-500">
                        Your cart is empty. Add a few dishes to get started.
                    </p>

                    <template v-else>
                        <p class="mt-2 text-sm text-ink-400">From {{ cart.state.caterer.company_name }}</p>
                        <ul class="mt-4 divide-y divide-ink-900/5 text-sm">
                            <li v-for="item in cart.state.items" :key="item.menu_item_id" class="flex justify-between gap-3 py-2">
                                <span class="text-ink-500">{{ item.quantity }} × {{ item.name }}</span>
                                <span class="shrink-0 font-medium text-ink-900">{{ money(item.price * item.quantity) }}</span>
                            </li>
                        </ul>
                        <div class="mt-4 flex items-center justify-between border-t border-ink-900/10 pt-4">
                            <span class="text-sm text-ink-500">Total</span>
                            <span class="font-display text-xl text-ink-900">{{ money(cart.total.value) }}</span>
                        </div>
                        <RouterLink to="/office/cart" class="btn-primary mt-4 w-full">Go to checkout</RouterLink>
                    </template>
                </aside>
            </div>
        </template>
    </div>
</template>
