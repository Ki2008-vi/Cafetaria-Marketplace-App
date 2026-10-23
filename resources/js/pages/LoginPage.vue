<script setup>
import { reactive, ref } from 'vue';
import { useRoute, useRouter, RouterLink } from 'vue-router';
import { useAuth } from '../stores/auth';

const route = useRoute();
const router = useRouter();
const { login, portalPath } = useAuth();

const form = reactive({
    email: '',
    password: '',
    remember: false,
});

const error = ref('');
const submitting = ref(false);

async function submit() {
    error.value = '';
    submitting.value = true;

    try {
        await login(form);
        const target = typeof route.query.redirect === 'string' ? route.query.redirect : portalPath.value;
        router.push(target);
    } catch (err) {
        error.value = err.message;
    } finally {
        submitting.value = false;
    }
}
</script>

<template>
    <div class="mx-auto flex max-w-md flex-col px-5 py-14">
        <div class="card p-7">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-ember-600">Welcome back</p>
            <h1 class="mt-2 font-display text-3xl text-ink-900">Log in to your portal</h1>
            <p class="mt-2 text-sm text-ink-500">Use the email address you registered with.</p>

            <p v-if="error" class="mt-5 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                {{ error }}
            </p>

            <form class="mt-6 space-y-4" @submit.prevent="submit">
                <div>
                    <label for="email" class="label">Email</label>
                    <input id="email" v-model="form.email" class="input" type="email" autocomplete="email" required />
                </div>

                <div>
                    <label for="password" class="label">Password</label>
                    <input
                        id="password"
                        v-model="form.password"
                        class="input"
                        type="password"
                        autocomplete="current-password"
                        required
                    />
                </div>

                <label class="flex items-center gap-2 text-sm text-ink-500">
                    <input v-model="form.remember" type="checkbox" class="rounded border-ink-900/20 text-leaf-700" />
                    Remember me
                </label>

                <button type="submit" class="btn-primary w-full" :disabled="submitting">
                    {{ submitting ? 'Logging in...' : 'Log in' }}
                </button>
            </form>

            <p class="mt-6 text-center text-sm text-ink-500">
                New here?
                <RouterLink to="/register" class="font-semibold text-leaf-700 hover:underline">Create an account</RouterLink>
            </p>
        </div>

        <div class="mt-6 rounded-2xl border border-ink-900/10 bg-white/60 p-4 text-xs leading-relaxed text-ink-400">
            <p class="font-semibold text-ink-500">Demo accounts</p>
            <p>merchant@catering.test / password</p>
            <p>office@company.test / password</p>
        </div>
    </div>
</template>
