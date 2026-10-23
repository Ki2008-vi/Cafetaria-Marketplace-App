import { computed, reactive, watch } from 'vue';

const STORAGE_KEY = 'catering-marketplace-cart';

function loadCart() {
    try {
        const stored = JSON.parse(localStorage.getItem(STORAGE_KEY) || 'null');

        if (stored?.caterer?.id && Array.isArray(stored.items)) {
            return {
                caterer: stored.caterer,
                items: stored.items,
            };
        }
    } catch {
        // A malformed local cart should never stop the app from loading.
    }

    return {
        caterer: null,
        items: [],
    };
}

const state = reactive(loadCart());

watch(
    state,
    (value) => {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(value));
    },
    { deep: true },
);

function add(caterer, menuItem, quantity = 1) {
    if (state.caterer?.id !== caterer.id) {
        state.caterer = {
            id: caterer.id,
            company_name: caterer.company_name,
            city: caterer.city,
        };
        state.items = [];
    }

    const existing = state.items.find((item) => item.menu_item_id === menuItem.id);

    if (existing) {
        existing.quantity = Math.min(existing.quantity + quantity, 1000);
        existing.price = menuItem.price;
        existing.name = menuItem.name;
        existing.photo_url = menuItem.photo_url;
    } else {
        state.items.push({
            menu_item_id: menuItem.id,
            name: menuItem.name,
            price: menuItem.price,
            photo_url: menuItem.photo_url,
            quantity: Math.min(quantity, 1000),
        });
    }
}

function setQuantity(menuItemId, quantity) {
    const item = state.items.find((entry) => entry.menu_item_id === menuItemId);

    if (!item) {
        return;
    }

    if (quantity <= 0) {
        remove(menuItemId);

        return;
    }

    item.quantity = Math.min(Number(quantity) || 1, 1000);
}

function increment(menuItemId) {
    const item = state.items.find((entry) => entry.menu_item_id === menuItemId);

    if (item) {
        setQuantity(menuItemId, item.quantity + 1);
    }
}

function decrement(menuItemId) {
    const item = state.items.find((entry) => entry.menu_item_id === menuItemId);

    if (item) {
        setQuantity(menuItemId, item.quantity - 1);
    }
}

function remove(menuItemId) {
    state.items = state.items.filter((item) => item.menu_item_id !== menuItemId);

    if (state.items.length === 0) {
        state.caterer = null;
    }
}

function clear() {
    state.caterer = null;
    state.items = [];
}

function hasDifferentCaterer(catererId) {
    return Boolean(state.caterer && state.caterer.id !== catererId);
}

const count = computed(() => state.items.reduce((total, item) => total + item.quantity, 0));
const total = computed(() => state.items.reduce((sum, item) => sum + Number(item.price) * item.quantity, 0));

export function useCart() {
    return {
        state,
        count,
        total,
        add,
        setQuantity,
        increment,
        decrement,
        remove,
        clear,
        hasDifferentCaterer,
    };
}
