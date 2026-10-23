<script setup>
import { onMounted, reactive, ref } from 'vue';
import { RouterLink, useRouter } from 'vue-router';
import { api } from '../../lib/api';
import { money, todayISO, tomorrowISO } from '../../lib/format';
import { useAuth } from '../../stores/auth';
import { useCart } from '../../stores/cart';

const router = useRouter();
const { state: authState } = useAuth();
const cart = useCart();

const form = reactive({
    delivery_date: tomorrowISO(),
    delivery_address: authState.user?.address || '',
    notes: '',
});

const error = ref('');
const submitting = ref(false);
const minDate = todayISO();

onMounted(() => {
    if (!form.delivery_address) {
        form.delivery_address = authState.user?.address || '';
    }
});

async function submit() {
    if (!cart.state.caterer || !cart.state.items.length) {
        return;
    }

    error.value = '';
    submitting.value = true;

    try {
        const payload = await api.post('/orders', {
            caterer_id: cart.state.caterer.id,
            delivery_date: form.delivery_date,
            delivery_address: form.delivery_address,
            notes: form.notes || null,
            items: cart.state.items.map((item) => ({
                menu_item_id: item.menu_item_id,
                quantity: item.quantity,
            })),
        });

        cart.clear();
        router.push({ name: 'invoices', query: { created: payload.order.order_number } });
    } catch (err) {
        error.value = err.message;
    } finally {
        submitting.value = false;
    }
}
</script>

<template>
    <div class="mx-auto max-w-5xl px-5 py-12">
        <div class="mb-7">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Checkout</p>
            <h1 class="mt-2 font-display text-3xl text-ink-900">Review your lunch order</h1>
        </div>

        <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {{ error }}
        </p>

        <div v-if="!cart.state.items.length" class="card p-10 text-center">
            <p class="font-display text-2xl text-ink-900">Your cart is empty</p>
            <p class="mt-2 text-sm text-ink-500">Browse a caterer and add dishes before checking out.</p>
            <RouterLink to="/office" class="btn-primary mt-5">Find a caterer</RouterLink>
        </div>

        <div v-else class="grid gap-6 lg:grid-cols-[1fr_360px]">
            <div class="space-y-6">
                <section class="card p-6">
                    <div class="flex items-center justify-between gap-3">
                        <div>
                            <h2 class="font-display text-xl text-ink-900">{{ cart.state.caterer.company_name }}</h2>
                            <p class="mt-1 text-sm text-ink-400">{{ cart.state.caterer.city }}</p>
                        </div>
                        <RouterLink
                            :to="{ name: 'caterer.show', params: { id: cart.state.caterer.id } }"
                            class="btn-ghost"
                        >
                            Add more
                        </RouterLink>
                    </div>

                    <ul class="mt-5 divide-y divide-ink-900/5">
                        <li v-for="item in cart.state.items" :key="item.menu_item_id" class="flex flex-wrap items-center gap-3 py-3">
                            <img
                                v-if="item.photo_url"
                                :src="item.photo_url"
                                :alt="item.name"
                                class="h-14 w-14 rounded-xl object-cover"
                            />
                            <div class="min-w-0 flex-1">
                                <p class="font-semibold text-ink-900">{{ item.name }}</p>
                                <p class="text-sm text-ink-400">{{ money(item.price) }} per portion</p>
                            </div>
                            <div class="flex items-center gap-2">
                                <button type="button" class="btn-ghost h-8 w-8 p-0" @click="cart.decrement(item.menu_item_id)">−</button>
                                <input
                                    class="input w-16 py-1 text-center"
                                    type="number"
                                    min="1"
                                    max="1000"
                                    :value="item.quantity"
                                    @change="cart.setQuantity(item.menu_item_id, $event.target.value)"
                                />
                                <button type="button" class="btn-ghost h-8 w-8 p-0" @click="cart.increment(item.menu_item_id)">+</button>
                            </div>
                            <p class="w-24 text-right font-semibold text-ink-900">{{ money(item.price * item.quantity) }}</p>
                            <button type="button" class="btn-ghost text-red-600" @click="cart.remove(item.menu_item_id)">Remove</button>
                        </li>
                    </ul>
                </section>

                <section class="card p-6">
                    <h2 class="font-display text-xl text-ink-900">Delivery details</h2>
                    <form class="mt-4 space-y-4" @submit.prevent="submit">
                        <div class="grid gap-4 sm:grid-cols-2">
                            <div>
                                <label class="label" for="delivery_date">Delivery date</label>
                                <input
                                    id="delivery_date"
                                    v-model="form.delivery_date"
                                    class="input"
                                    type="date"
                                    :min="minDate"
                                    required
                                />
                            </div>
                            <div>
                                <label class="label" for="delivery_address">Delivery address</label>
                                <input id="delivery_address" v-model="form.delivery_address" class="input" required />
                            </div>
                        </div>
                        <div>
                            <label class="label" for="notes">Notes for the caterer (optional)</label>
                            <textarea
                                id="notes"
                                v-model="form.notes"
                                class="input min-h-24"
                                rows="3"
                                placeholder="Allergies, packing instructions, floor number..."
                            ></textarea>
                        </div>
                    </form>
                </section>
            </div>

            <aside class="card h-fit p-6 lg:sticky lg:top-24">
                <h2 class="font-display text-xl text-ink-900">Order summary</h2>
                <dl class="mt-5 space-y-3 text-sm">
                    <div class="flex justify-between gap-3">
                        <dt class="text-ink-500">Portions</dt>
                        <dd class="font-semibold text-ink-900">{{ cart.count.value }}</dd>
                    </div>
                    <div class="flex justify-between gap-3">
                        <dt class="text-ink-500">Subtotal</dt>
                        <dd class="font-semibold text-ink-900">{{ money(cart.total.value) }}</dd>
                    </div>
                    <div class="flex justify-between gap-3">
                        <dt class="text-ink-500">Delivery</dt>
                        <dd class="font-semibold text-ink-900">Included</dd>
                    </div>
                    <div class="flex justify-between gap-3 border-t border-ink-900/10 pt-3">
                        <dt class="font-semibold text-ink-700">Total</dt>
                        <dd class="font-display text-2xl text-ink-900">{{ money(cart.total.value) }}</dd>
                    </div>
                </dl>

                <button type="button" class="btn-primary mt-6 w-full" :disabled="submitting" @click="submit">
                    {{ submitting ? 'Placing order...' : 'Place order' }}
                </button>
                <p class="mt-3 text-xs leading-relaxed text-ink-400">
                    An invoice is generated immediately and is visible to both your office and the caterer.
                </p>
            </aside>
        </div>
    </div>
</template>
