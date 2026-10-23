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

const invoice = ref(null);
const loading = ref(true);
const error = ref('');
const paying = ref(false);

async function load() {
    loading.value = true;
    error.value = '';

    try {
        const payload = await api.get(`/invoices/${route.params.id}`);
        invoice.value = payload.invoice;
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}

function printInvoice() {
    window.print();
}

async function pay() {
    const confirmed = await ask({
        title: 'Konfirmasi Pembayaran Faktur',
        message: `Tandai faktur ${invoice.value.invoice_number} sebesar ${money(invoice.value.total_amount)} sebagai sudah LUNAS?`,
        confirmText: 'Ya, Tandai Lunas',
        cancelText: 'Batal',
        type: 'info',
    });

    if (!confirmed) {
        return;
    }

    paying.value = true;
    error.value = '';

    try {
        const payload = await api.post(`/invoices/${invoice.value.id}/pay`);
        invoice.value = payload.invoice;
    } catch (err) {
        error.value = err.message;
    } finally {
        paying.value = false;
    }
}

onMounted(load);
</script>

<template>
    <div class="mx-auto max-w-4xl px-5 py-12 print:p-0 print:m-0 print:max-w-none">
        <div class="no-print print:hidden mb-6 flex flex-wrap items-center justify-between gap-3">
            <RouterLink to="/invoices" class="btn-ghost">← Back to invoices</RouterLink>
            <div class="flex gap-2">
                <button v-if="invoice" type="button" class="btn-secondary" @click="printInvoice">Print</button>
                <button
                    v-if="invoice && isOffice && invoice.status === 'unpaid'"
                    type="button"
                    class="btn-accent"
                    :disabled="paying"
                    @click="pay"
                >
                    {{ paying ? 'Saving...' : 'Mark as paid' }}
                </button>
            </div>
        </div>

        <p v-if="error" class="no-print print:hidden mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {{ error }}
        </p>

        <div v-if="loading" class="card h-96 animate-pulse bg-cream-100"></div>

        <article v-else-if="invoice" class="card print-card p-7 sm:p-10 print:p-0 print:border-0 print:shadow-none">
            <header class="flex flex-wrap items-start justify-between gap-6 border-b border-ink-900/10 pb-7">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.2em] text-ember-600">Catering Marketplace</p>
                    <h1 class="mt-2 font-display text-3xl text-ink-900">Invoice</h1>
                    <p class="mt-1 text-sm text-ink-400">{{ invoice.invoice_number }}</p>
                </div>
                <StatusBadge :status="invoice.status" />
            </header>

            <div class="grid gap-6 py-7 sm:grid-cols-2">
                <div>
                    <p class="label">From</p>
                    <p class="font-display text-lg text-ink-900">{{ invoice.order.caterer.company_name }}</p>
                    <p class="mt-1 text-sm leading-relaxed text-ink-500">
                        {{ invoice.order.caterer.address }}<br />
                        {{ invoice.order.caterer.city }}<br />
                        {{ invoice.order.caterer.phone }}<br />
                        {{ invoice.order.caterer.email }}
                    </p>
                </div>
                <div>
                    <p class="label">Bill to</p>
                    <p class="font-display text-lg text-ink-900">{{ invoice.order.office.company_name }}</p>
                    <p class="mt-1 text-sm leading-relaxed text-ink-500">
                        {{ invoice.order.office.address }}<br />
                        {{ invoice.order.office.city }}<br />
                        {{ invoice.order.office.phone }}<br />
                        {{ invoice.order.office.email }}
                    </p>
                </div>
            </div>

            <div class="grid gap-3 rounded-2xl bg-cream-50 p-4 text-sm text-ink-500 sm:grid-cols-4">
                <p><span class="block text-[10px] font-bold uppercase tracking-wider text-ink-400">Order</span>{{ invoice.order.order_number }}</p>
                <p><span class="block text-[10px] font-bold uppercase tracking-wider text-ink-400">Issued</span>{{ formatDate(invoice.issued_at) }}</p>
                <p><span class="block text-[10px] font-bold uppercase tracking-wider text-ink-400">Due</span>{{ formatDate(invoice.due_at) }}</p>
                <p><span class="block text-[10px] font-bold uppercase tracking-wider text-ink-400">Delivery</span>{{ formatDate(invoice.order.delivery_date) }}</p>
            </div>

            <div class="table-wrap mt-7">
                <table class="data-table min-w-0">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Qty</th>
                            <th>Unit price</th>
                            <th class="text-right">Line total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in invoice.order.items" :key="item.id">
                            <td class="font-medium text-ink-900">{{ item.name }}</td>
                            <td>{{ item.quantity }}</td>
                            <td>{{ money(item.unit_price) }}</td>
                            <td class="text-right">{{ money(item.line_total) }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="mt-6 flex justify-end">
                <div class="w-full max-w-xs rounded-2xl bg-leaf-50 p-5">
                    <div class="flex items-center justify-between text-sm text-ink-500">
                        <span>Total</span>
                        <span class="font-display text-2xl text-ink-900">{{ money(invoice.total) }}</span>
                    </div>
                    <p class="mt-2 text-xs text-ink-400">
                        {{ invoice.status === 'paid' ? `Paid ${formatDateTime(invoice.paid_at)}` : 'Payment due by ' + formatDate(invoice.due_at) }}
                    </p>
                </div>
            </div>

            <p v-if="invoice.order.notes" class="mt-7 border-t border-ink-900/10 pt-5 text-sm text-ink-500">
                <span class="font-semibold text-ink-700">Order notes:</span> {{ invoice.order.notes }}
            </p>
        </article>
    </div>
</template>
