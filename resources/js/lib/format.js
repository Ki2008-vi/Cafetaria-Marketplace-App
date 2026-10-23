const currency = new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    maximumFractionDigits: 0,
});

const dateFormatter = new Intl.DateTimeFormat('en-GB', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
});

const dateTimeFormatter = new Intl.DateTimeFormat('en-GB', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
});

export function money(value) {
    return currency.format(Number(value || 0));
}

export function formatDate(value) {
    if (!value) {
        return '—';
    }

    return dateFormatter.format(new Date(value));
}

export function formatDateTime(value) {
    if (!value) {
        return '—';
    }

    return dateTimeFormatter.format(new Date(value));
}

export function todayISO() {
    return new Date().toISOString().slice(0, 10);
}

export function tomorrowISO() {
    const date = new Date();
    date.setDate(date.getDate() + 1);

    return date.toISOString().slice(0, 10);
}

export function titleCase(value) {
    if (!value) {
        return '';
    }

    return value.charAt(0).toUpperCase() + value.slice(1);
}

export function statusTone(status) {
    if (['delivered', 'paid', 'confirmed'].includes(status)) {
        return 'badge-green';
    }

    if (['pending', 'preparing', 'unpaid'].includes(status)) {
        return 'badge-amber';
    }

    if (['cancelled', 'overdue'].includes(status)) {
        return 'badge-red';
    }

    return 'badge-gray';
}
