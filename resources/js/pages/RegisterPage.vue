<script setup>
import { computed, reactive, ref } from 'vue';
import { RouterLink, useRouter } from 'vue-router';
import { useAuth } from '../stores/auth';

const router = useRouter();
const { register } = useAuth();

const form = reactive({
    role: 'office',
    name: '',
    company_name: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    cuisine_type: '',
    description: '',
    password: '',
    password_confirmation: '',
});

const error = ref('');
const errors = ref({});
const submitting = ref(false);

const isMerchant = computed(() => form.role === 'merchant');

function fieldError(name) {
    return errors.value[name]?.[0] || '';
}

async function submit() {
    error.value = '';
    errors.value = {};
    submitting.value = true;

    try {
        await register({
            ...form,
            cuisine_type: isMerchant.value ? form.cuisine_type : null,
        });

        router.push(isMerchant.value ? '/merchant' : '/office');
    } catch (err) {
        error.value = err.message;
        errors.value = err.errors || {};
    } finally {
        submitting.value = false;
    }
}
</script>

<template>
    <div class="mx-auto max-w-3xl px-5 py-12">
        <div class="mb-7 text-center">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Create an account</p>
            <h1 class="mt-2 font-display text-3xl text-ink-900 sm:text-4xl">Choose how you want to use the marketplace</h1>
        </div>

        <div class="card p-6 sm:p-8">
            <div class="mb-7 grid gap-3 sm:grid-cols-2">
                <button
                    type="button"
                    class="rounded-2xl border p-4 text-left transition"
                    :class="form.role === 'office' ? 'border-leaf-600 bg-leaf-50' : 'border-ink-900/10 bg-white hover:border-leaf-200'"
                    @click="form.role = 'office'"
                >
                    <span class="block font-display text-lg text-ink-900">I need lunch</span>
                    <span class="mt-1 block text-sm text-ink-500">Register as an office and order from caterers.</span>
                </button>
                <button
                    type="button"
                    class="rounded-2xl border p-4 text-left transition"
                    :class="form.role === 'merchant' ? 'border-leaf-600 bg-leaf-50' : 'border-ink-900/10 bg-white hover:border-leaf-200'"
                    @click="form.role = 'merchant'"
                >
                    <span class="block font-display text-lg text-ink-900">I provide catering</span>
                    <span class="mt-1 block text-sm text-ink-500">Register as a caterer and publish your menu.</span>
                </button>
            </div>

            <p v-if="error" class="mb-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                {{ error }}
            </p>

            <form class="grid gap-4 sm:grid-cols-2" @submit.prevent="submit">
                <div>
                    <label class="label" for="company_name">Company name</label>
                    <input id="company_name" v-model="form.company_name" class="input" required />
                    <p v-if="fieldError('company_name')" class="field-error">{{ fieldError('company_name') }}</p>
                </div>

                <div>
                    <label class="label" for="name">Contact person</label>
                    <input id="name" v-model="form.name" class="input" required />
                    <p v-if="fieldError('name')" class="field-error">{{ fieldError('name') }}</p>
                </div>

                <div>
                    <label class="label" for="email">Email</label>
                    <input id="email" v-model="form.email" class="input" type="email" required />
                    <p v-if="fieldError('email')" class="field-error">{{ fieldError('email') }}</p>
                </div>

                <div>
                    <label class="label" for="phone">Phone</label>
                    <input id="phone" v-model="form.phone" class="input" required />
                    <p v-if="fieldError('phone')" class="field-error">{{ fieldError('phone') }}</p>
                </div>

                <div class="sm:col-span-2">
                    <label class="label" for="address">Address</label>
                    <input id="address" v-model="form.address" class="input" required />
                    <p v-if="fieldError('address')" class="field-error">{{ fieldError('address') }}</p>
                </div>

                <div>
                    <label class="label" for="city">City</label>
                    <input id="city" v-model="form.city" class="input" required />
                    <p v-if="fieldError('city')" class="field-error">{{ fieldError('city') }}</p>
                </div>

                <div v-if="isMerchant">
                    <label class="label" for="cuisine_type">Cuisine type</label>
                    <input id="cuisine_type" v-model="form.cuisine_type" class="input" placeholder="Indonesian, Healthy..." required />
                    <p v-if="fieldError('cuisine_type')" class="field-error">{{ fieldError('cuisine_type') }}</p>
                </div>

                <div class="sm:col-span-2">
                    <label class="label" for="description">
                        {{ isMerchant ? 'Tell offices about your kitchen' : 'About your office (optional)' }}
                    </label>
                    <textarea id="description" v-model="form.description" class="input min-h-24" rows="4"></textarea>
                    <p v-if="fieldError('description')" class="field-error">{{ fieldError('description') }}</p>
                </div>

                <div>
                    <label class="label" for="password">Password</label>
                    <input id="password" v-model="form.password" class="input" type="password" required />
                    <p v-if="fieldError('password')" class="field-error">{{ fieldError('password') }}</p>
                </div>

                <div>
                    <label class="label" for="password_confirmation">Confirm password</label>
                    <input
                        id="password_confirmation"
                        v-model="form.password_confirmation"
                        class="input"
                        type="password"
                        required
                    />
                </div>

                <div class="sm:col-span-2">
                    <button type="submit" class="btn-primary w-full" :disabled="submitting">
                        {{ submitting ? 'Creating account...' : 'Create account' }}
                    </button>
                </div>
            </form>

            <p class="mt-6 text-center text-sm text-ink-500">
                Already registered?
                <RouterLink to="/login" class="font-semibold text-leaf-700 hover:underline">Log in</RouterLink>
            </p>
        </div>
    </div>
</template>
