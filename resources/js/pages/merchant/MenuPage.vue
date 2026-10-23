<script setup>
import { onMounted, reactive, ref } from 'vue';
import { api } from '../../lib/api';
import { money } from '../../lib/format';

const items = ref([]);
const loading = ref(true);
const saving = ref(false);
const error = ref('');
const fieldErrors = ref({});
const editingId = ref(null);
const preview = ref('');
const photoInput = ref(null);

const form = reactive({
    name: '',
    description: '',
    price: '',
    is_available: true,
    photo: null,
});

function fieldError(name) {
    return fieldErrors.value[name]?.[0] || '';
}

async function load() {
    loading.value = true;

    try {
        items.value = await api.get('/merchant/menu-items');
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}

function resetForm() {
    form.name = '';
    form.description = '';
    form.price = '';
    form.is_available = true;
    form.photo = null;
    editingId.value = null;
    preview.value = '';
    fieldErrors.value = {};

    if (photoInput.value) {
        photoInput.value.value = '';
    }
}

function edit(item) {
    editingId.value = item.id;
    form.name = item.name;
    form.description = item.description;
    form.price = String(item.price);
    form.is_available = item.is_available;
    form.photo = null;
    preview.value = item.photo_url || '';
    fieldErrors.value = {};

    if (photoInput.value) {
        photoInput.value.value = '';
    }

    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function onPhoto(event) {
    const file = event.target.files?.[0] || null;
    form.photo = file;

    if (file) {
        preview.value = URL.createObjectURL(file);
    }
}

async function submit() {
    saving.value = true;
    error.value = '';
    fieldErrors.value = {};

    try {
        if (!editingId.value && !form.photo) {
            fieldErrors.value = { photo: ['A menu photo is required.'] };
            return;
        }

        const payload = new FormData();
        payload.append('name', form.name);
        payload.append('description', form.description);
        payload.append('price', form.price);
        payload.append('is_available', form.is_available ? '1' : '0');

        if (form.photo) {
            payload.append('photo', form.photo);
        }

        if (editingId.value) {
            await api.upload(`/merchant/menu-items/${editingId.value}`, payload, 'PUT');
        } else {
            await api.upload('/merchant/menu-items', payload);
        }

        resetForm();
        await load();
    } catch (err) {
        error.value = err.message;
        fieldErrors.value = err.errors || {};
    } finally {
        saving.value = false;
    }
}

async function remove(item) {
    if (!window.confirm(`Remove "${item.name}" from your menu?`)) {
        return;
    }

    error.value = '';

    try {
        await api.delete(`/merchant/menu-items/${item.id}`);
        items.value = items.value.filter((entry) => entry.id !== item.id);

        if (editingId.value === item.id) {
            resetForm();
        }
    } catch (err) {
        error.value = err.message;
    }
}

onMounted(load);
</script>

<template>
    <div class="mx-auto max-w-6xl px-5 py-12">
        <div class="mb-7">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Your kitchen</p>
            <h1 class="mt-2 font-display text-3xl text-ink-900">Menu management</h1>
            <p class="mt-2 text-sm text-ink-500">Add dishes, update prices, and control what offices can order.</p>
        </div>

        <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {{ error }}
        </p>

        <div class="grid gap-6 lg:grid-cols-[0.9fr_1.1fr]">
            <section class="card h-fit p-6">
                <div class="mb-5 flex items-center justify-between gap-3">
                    <h2 class="font-display text-2xl text-ink-900">
                        {{ editingId ? 'Edit menu item' : 'Add a menu item' }}
                    </h2>
                    <button v-if="editingId" type="button" class="btn-ghost" @click="resetForm">Cancel</button>
                </div>

                <form class="space-y-4" @submit.prevent="submit">
                    <div>
                        <label class="label" for="name">Name</label>
                        <input id="name" v-model="form.name" class="input" required />
                        <p v-if="fieldError('name')" class="field-error">{{ fieldError('name') }}</p>
                    </div>

                    <div>
                        <label class="label" for="description">Description</label>
                        <textarea id="description" v-model="form.description" class="input min-h-24" rows="4" required></textarea>
                        <p v-if="fieldError('description')" class="field-error">{{ fieldError('description') }}</p>
                    </div>

                    <div>
                        <label class="label" for="price">Price per portion</label>
                        <input id="price" v-model="form.price" class="input" type="number" min="0.01" step="0.01" required />
                        <p v-if="fieldError('price')" class="field-error">{{ fieldError('price') }}</p>
                    </div>

                    <div>
                        <label class="label" for="photo">Photo</label>
                        <input
                            id="photo"
                            ref="photoInput"
                            class="input"
                            type="file"
                            accept="image/*"
                            @change="onPhoto"
                        />
                        <p class="mt-1 text-xs text-ink-400">
                            {{ editingId ? 'Leave empty to keep the current photo.' : 'JPG, PNG, or WebP up to 4 MB.' }}
                        </p>
                        <p v-if="fieldError('photo')" class="field-error">{{ fieldError('photo') }}</p>
                    </div>

                    <div v-if="preview" class="overflow-hidden rounded-2xl border border-ink-900/10">
                        <img :src="preview" alt="Menu item preview" class="h-48 w-full object-cover" />
                    </div>

                    <label class="flex items-center gap-2 text-sm text-ink-500">
                        <input v-model="form.is_available" type="checkbox" class="rounded border-ink-900/20 text-leaf-700" />
                        Available for ordering
                    </label>

                    <button type="submit" class="btn-primary w-full" :disabled="saving">
                        {{ saving ? 'Saving...' : editingId ? 'Save changes' : 'Add to menu' }}
                    </button>
                </form>
            </section>

            <section>
                <div class="mb-3 flex items-center justify-between gap-3">
                    <h2 class="font-display text-2xl text-ink-900">Your dishes</h2>
                    <span class="badge-gray">{{ items.length }} items</span>
                </div>

                <div v-if="loading" class="space-y-3">
                    <div v-for="n in 3" :key="n" class="card h-28 animate-pulse bg-cream-100"></div>
                </div>

                <p v-else-if="!items.length" class="card p-8 text-center text-sm text-ink-500">
                    Your menu is empty. Add your first dish on the left.
                </p>

                <div v-else class="space-y-3">
                    <article v-for="item in items" :key="item.id" class="card flex gap-4 p-4">
                        <img
                            v-if="item.photo_url"
                            :src="item.photo_url"
                            :alt="item.name"
                            class="h-24 w-24 shrink-0 rounded-2xl object-cover"
                        />
                        <div v-else class="grid h-24 w-24 shrink-0 place-items-center rounded-2xl bg-leaf-100 text-2xl">🍲</div>

                        <div class="min-w-0 flex-1">
                            <div class="flex flex-wrap items-start justify-between gap-2">
                                <div>
                                    <h3 class="font-semibold text-ink-900">{{ item.name }}</h3>
                                    <p class="mt-1 text-sm font-semibold text-leaf-700">{{ money(item.price) }}</p>
                                </div>
                                <span :class="item.is_available ? 'badge-green' : 'badge-gray'">
                                    {{ item.is_available ? 'Available' : 'Hidden' }}
                                </span>
                            </div>
                            <p class="mt-2 line-clamp-2 text-sm text-ink-500">{{ item.description }}</p>
                            <div class="mt-3 flex gap-2">
                                <button type="button" class="btn-secondary" @click="edit(item)">Edit</button>
                                <button type="button" class="btn-danger" @click="remove(item)">Delete</button>
                            </div>
                        </div>
                    </article>
                </div>
            </section>
        </div>
    </div>
</template>
