<script setup>
import { onMounted, ref } from 'vue';
import { RouterLink } from 'vue-router';
import StatusBadge from '../components/StatusBadge.vue';
import { api } from '../lib/api';
import { formatDate, money, titleCase } from '../lib/format';
import { useAuth } from '../stores/auth';

const { isMerchant, isOffice } = useAuth();

const orders = ref([]);
const loading = ref(true);
const error = ref('');
const updating = ref(null);
const statuses = ['pending', 'confirmed', 'preparing', 'delivered', 'cancelled'];

async function load() {
    loading.value = true;
    error.value = '';

    try {
        orders.value = await api.get('/orders');
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}

async function updateStatus(order, status) {
    updating.value = order.id;
    error.value = '';

    try {
        const payload = await api.patch(`/merchant/orders/${order.id}/status`, { status });
        const index = orders.value.findIndex((entry) => entry.id === order.id);

        if (index !== -1) {
            orders.value[index] = payload.order;
        }
    } catch (err) {
        error.value = err.message;
    } finally {
        updating.value = null;
    }
}

onMounted(load);
</script>

<template>
    <div class="mx-auto max-w-6xl px-5 py-12">
        <div class="mb-7 flex flex-wrap items-end justify-between gap-4">
            <div>
                <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Order history</p>
                <h1 class="mt-2 font-display text-3xl text-ink-900">Orders</h1>
                <p class="mt-2 text-sm text-ink-500">
                    {{ isMerchant ? 'Orders placed with your kitchen.' : 'Lunches your office has ordered.' }}
                </p>
            </div>
            <RouterLink v-if="isOffice" to="/office" class="btn-secondary">Order again</RouterLink>
        </div>

        <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {{ error }}
        </p>

        <div v-if="loading" class="space-y-4">
            <div v-for="n in 3" :key="n" class="card h-40 animate-pulse bg-cream-100"></div>
        </div>

        <div v-else-if="!orders.length" class="card p-10 text-center">
            <p class="font-display text-2xl text-ink-900">No orders yet</p>
            <p class="mt-2 text-sm text-ink-500">
                {{ isOffice ? 'Find a caterer and place your first lunch order.' : 'New orders will appear here.' }}
            </p>
            <RouterLink v-if="isOffice" to="/office" class="btn-primary mt-5">Browse caterers</RouterLink>
        </div>

        <div v-else class="space-y-4">
            <article v-for="order in orders" :key="order.id" class="card p-5 sm:p-6">
                <div class="flex flex-wrap items-start justify-between gap-3">
                    <div>
                        <p class="text-[11px] font-bold uppercase tracking-[0.16em] text-ink-400">
                            {{ order.order_number }} · {{ formatDate(order.created_at) }}
                        </p>
                        <h2 class="mt-1 font-display text-xl text-ink-900">
                            {{ isMerchant ? order.office.company_name : order.caterer.company_name }}
                        </h2>
                    </div>
                    <StatusBadge :status="order.status" />
                </div>

                <div class="mt-4 grid gap-3 rounded-2xl bg-cream-50 p-4 text-sm text-ink-500 sm:grid-cols-2">
                    <p>
                        <span class="font-semibold text-ink-700">Delivery:</span>
                        {{ formatDate(order.delivery_date) }}
                    </p>
                    <p>
                        <span class="font-semibold text-ink-700">Address:</span>
                        {{ order.delivery_address }}
                    </p>
                    <p v-if="order.notes" class="sm:col-span-2">
                        <span class="font-semibold text-ink-700">Notes:</span>
                        {{ order.notes }}
                    </p>
                </div>

                <ul class="mt-4 divide-y divide-ink-900/5 text-sm">
                    <li v-for="item in order.items" :key="item.id" class="flex items-center justify-between gap-4 py-2">
                        <span class="text-ink-700">{{ item.quantity }} × {{ item.name }}</span>
                        <span class="shrink-0 text-ink-500">{{ money(item.line_total) }}</span>
                    </li>
                </ul>

                <div class="mt-4 flex flex-wrap items-center justify-between gap-3 border-t border-ink-900/5 pt-4">
                    <p class="font-display text-xl text-ink-900">{{ money(order.total) }}</p>

                    <div class="flex flex-wrap items-center gap-2">
                        <select
                            v-if="isMerchant"
                            class="input max-w-44"
                            :value="order.status"
                            :disabled="updating === order.id"
                            @change="updateStatus(order, $event.target.value)"
                        >
                            <option v-for="status in statuses" :key="status" :value="status">
                                {{ titleCase(status) }}
                            </option>
                        </select>

                        <RouterLink
                            v-if="order.invoice"
                            :to="{ name: 'invoices.show', params: { id: order.invoice.id } }"
                            class="btn-secondary"
                        >
                            View invoice
                        </RouterLink>
                    </div>
                </div>
            </article>
        </div>
    </div>
</template>
