<script setup>
import { onMounted, ref } from 'vue';
import { RouterLink, useRoute } from 'vue-router';
import StatusBadge from '../components/StatusBadge.vue';
import { api } from '../lib/api';
import { formatDate, formatDateTime, money } from '../lib/format';
import { useAuth } from '../stores/auth';
import { useConfirm } from '../stores/confirm';

const route = useRoute();
const { isOffice } = useAuth();
const { ask } = useConfirm();

const invoices = ref([]);
const loading = ref(true);
const error = ref('');
const paying = ref(null);

async function load() {
    loading.value = true;
    error.value = '';

    try {
        invoices.value = await api.get('/invoices');
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}

async function pay(invoice) {
    const confirmed = await ask({
        title: 'Konfirmasi Pembayaran Faktur',
        message: `Tandai faktur ${invoice.invoice_number} sebesar ${money(invoice.total_amount)} sebagai sudah LUNAS?`,
        confirmText: 'Ya, Tandai Lunas',
        cancelText: 'Batal',
        type: 'info',
    });

    if (!confirmed) {
        return;
    }

    paying.value = invoice.id;
    error.value = '';

    try {
        const payload = await api.post(`/invoices/${invoice.id}/pay`);
        const index = invoices.value.findIndex((entry) => entry.id === invoice.id);

        if (index !== -1) {
            invoices.value[index] = payload.invoice;
        }
    } catch (err) {
        error.value = err.message;
    } finally {
        paying.value = null;
    }
}

onMounted(load);
</script>

<template>
    <div class="mx-auto max-w-6xl px-5 py-12">
        <div class="mb-7">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Billing</p>
            <h1 class="mt-2 font-display text-3xl text-ink-900">Invoices</h1>
            <p class="mt-2 text-sm text-ink-500">Every order gets one invoice, visible to both parties.</p>
        </div>

        <p
            v-if="route.query.created"
            class="mb-5 rounded-xl border border-leaf-200 bg-leaf-50 px-4 py-3 text-sm text-leaf-700"
        >
            Order {{ route.query.created }} was created. The invoice is ready below.
        </p>

        <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {{ error }}
        </p>

        <div v-if="loading" class="card h-64 animate-pulse bg-cream-100"></div>

        <div v-else-if="!invoices.length" class="card p-10 text-center">
            <p class="font-display text-2xl text-ink-900">No invoices yet</p>
            <p class="mt-2 text-sm text-ink-500">Invoices are created automatically when an order is placed.</p>
        </div>

        <div v-else class="card overflow-hidden">
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Invoice</th>
                            <th>Order</th>
                            <th>Company</th>
                            <th>Issued</th>
                            <th>Due</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="invoice in invoices" :key="invoice.id">
                            <td class="font-semibold text-ink-900">{{ invoice.invoice_number }}</td>
                            <td>{{ invoice.order.order_number }}</td>
                            <td>
                                {{ isOffice ? invoice.order.caterer.company_name : invoice.order.office.company_name }}
                            </td>
                            <td>{{ formatDate(invoice.issued_at) }}</td>
                            <td>{{ formatDate(invoice.due_at) }}</td>
                            <td class="font-semibold">{{ money(invoice.total) }}</td>
                            <td><StatusBadge :status="invoice.status" /></td>
                            <td>
                                <div class="flex flex-wrap justify-end gap-2">
                                    <button
                                        v-if="isOffice && invoice.status === 'unpaid'"
                                        type="button"
                                        class="btn-accent"
                                        :disabled="paying === invoice.id"
                                        @click="pay(invoice)"
                                    >
                                        {{ paying === invoice.id ? 'Saving...' : 'Mark paid' }}
                                    </button>
                                    <RouterLink
                                        :to="{ name: 'invoices.show', params: { id: invoice.id } }"
                                        class="btn-secondary"
                                    >
                                        View
                                    </RouterLink>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <p v-if="!loading && invoices.length" class="mt-3 text-xs text-ink-400">
            Last refreshed {{ formatDateTime(new Date()) }}
        </p>
    </div>
</template>
