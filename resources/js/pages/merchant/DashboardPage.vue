<script setup>
import { onMounted, ref } from 'vue';
import { RouterLink } from 'vue-router';
import StatusBadge from '../../components/StatusBadge.vue';
import { api } from '../../lib/api';
import { formatDate, money } from '../../lib/format';
import { useAuth } from '../../stores/auth';

const { state } = useAuth();

const data = ref(null);
const loading = ref(true);
const error = ref('');

async function load() {
    loading.value = true;
    error.value = '';

    try {
        data.value = await api.get('/dashboard');
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}

onMounted(load);
</script>

<template>
    <div class="mx-auto max-w-6xl px-5 py-12">
        <div class="mb-7 flex flex-wrap items-end justify-between gap-4">
            <div>
                <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Caterer portal</p>
                <h1 class="mt-2 font-display text-3xl text-ink-900">Good to see you, {{ state.user.company_name }}</h1>
                <p class="mt-2 text-sm text-ink-500">Here is how your kitchen is doing today.</p>
            </div>
            <RouterLink to="/merchant/menu" class="btn-primary">Manage menu</RouterLink>
        </div>

        <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {{ error }}
        </p>

        <div v-if="loading" class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div v-for="n in 4" :key="n" class="card h-28 animate-pulse bg-cream-100"></div>
        </div>

        <template v-else-if="data">
            <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <div class="card p-5">
                    <p class="text-xs font-bold uppercase tracking-[0.16em] text-ink-400">Menu items</p>
                    <p class="mt-3 font-display text-4xl text-ink-900">{{ data.stats.menu_items }}</p>
                </div>
                <div class="card p-5">
                    <p class="text-xs font-bold uppercase tracking-[0.16em] text-ink-400">Total orders</p>
                    <p class="mt-3 font-display text-4xl text-ink-900">{{ data.stats.orders }}</p>
                </div>
                <div class="card p-5">
                    <p class="text-xs font-bold uppercase tracking-[0.16em] text-ink-400">Pending</p>
                    <p class="mt-3 font-display text-4xl text-ember-600">{{ data.stats.pending_orders }}</p>
                </div>
                <div class="card p-5">
                    <p class="text-xs font-bold uppercase tracking-[0.16em] text-ink-400">Paid revenue</p>
                    <p class="mt-3 font-display text-2xl text-leaf-700">{{ money(data.stats.paid_revenue) }}</p>
                </div>
            </div>

            <div class="mt-8 card p-6">
                <div class="mb-4 flex items-center justify-between gap-3">
                    <h2 class="font-display text-2xl text-ink-900">Recent orders</h2>
                    <RouterLink to="/orders" class="btn-ghost">See all</RouterLink>
                </div>

                <p v-if="!data.recent_orders.length" class="py-8 text-center text-sm text-ink-500">
                    No orders yet. Once an office orders, it will appear here.
                </p>

                <div v-else class="table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order</th>
                                <th>Office</th>
                                <th>Delivery</th>
                                <th>Total</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="order in data.recent_orders" :key="order.id">
                                <td class="font-semibold text-ink-900">{{ order.order_number }}</td>
                                <td>{{ order.office.company_name }}</td>
                                <td>{{ formatDate(order.delivery_date) }}</td>
                                <td>{{ money(order.total) }}</td>
                                <td><StatusBadge :status="order.status" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </template>
    </div>
</template>
