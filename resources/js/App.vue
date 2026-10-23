<script setup>
import { RouterLink, RouterView, useRouter } from 'vue-router';
import { useAuth } from './stores/auth';
import { useCart } from './stores/cart';

const router = useRouter();
const { state, isAuthenticated, isMerchant, isOffice, logout } = useAuth();
const { count, clear } = useCart();

async function signOut() {
    await logout();
    clear();
    router.push('/');
}
</script>

<template>
    <div class="flex min-h-screen flex-col">
        <header class="sticky top-0 z-30 border-b border-ink-900/10 bg-cream-50/90 backdrop-blur">
            <div class="mx-auto flex max-w-6xl flex-wrap items-center justify-between gap-3 px-5 py-4">
                <RouterLink to="/" class="flex items-center gap-3">
                    <span class="grid h-10 w-10 place-items-center rounded-full bg-leaf-700 font-display text-lg font-bold text-white">
                        C
                    </span>
                    <span>
                        <span class="block font-display text-lg leading-tight">Catering Marketplace</span>
                        <span class="hidden text-[10px] uppercase tracking-[0.3em] text-ink-400 sm:block">
                            Office lunches, sorted
                        </span>
                    </span>
                </RouterLink>

                <nav class="flex flex-wrap items-center justify-end gap-1 text-sm font-semibold text-ink-500">
                    <template v-if="isOffice">
                        <RouterLink to="/office" class="rounded-full px-3 py-2 hover:bg-ink-900/5">Find caterers</RouterLink>
                        <RouterLink to="/orders" class="rounded-full px-3 py-2 hover:bg-ink-900/5">Orders</RouterLink>
                        <RouterLink to="/invoices" class="rounded-full px-3 py-2 hover:bg-ink-900/5">Invoices</RouterLink>
                    </template>

                    <template v-if="isMerchant">
                        <RouterLink to="/merchant" class="rounded-full px-3 py-2 hover:bg-ink-900/5">Dashboard</RouterLink>
                        <RouterLink to="/merchant/menu" class="rounded-full px-3 py-2 hover:bg-ink-900/5">Menu</RouterLink>
                        <RouterLink to="/orders" class="rounded-full px-3 py-2 hover:bg-ink-900/5">Orders</RouterLink>
                        <RouterLink to="/invoices" class="rounded-full px-3 py-2 hover:bg-ink-900/5">Invoices</RouterLink>
                    </template>

                    <RouterLink
                        v-if="isOffice"
                        to="/office/cart"
                        class="relative rounded-full px-3 py-2 hover:bg-ink-900/5"
                    >
                        Cart
                        <span
                            v-if="count"
                            class="ml-1 inline-grid h-5 min-w-5 place-items-center rounded-full bg-ember-500 px-1 text-[10px] text-white"
                        >
                            {{ count }}
                        </span>
                    </RouterLink>

                    <template v-if="isAuthenticated">
                        <RouterLink to="/profile" class="rounded-full px-3 py-2 hover:bg-ink-900/5">
                            {{ state.user.company_name }}
                        </RouterLink>
                        <button type="button" class="btn-ghost" @click="signOut">Sign out</button>
                    </template>

                    <template v-else>
                        <RouterLink to="/login" class="btn-ghost">Log in</RouterLink>
                        <RouterLink to="/register" class="btn-primary">Get started</RouterLink>
                    </template>
                </nav>
            </div>
        </header>

        <main class="flex-1">
            <RouterView />
        </main>

        <footer class="border-t border-ink-900/10 bg-cream-100/60">
            <div class="mx-auto flex max-w-6xl flex-col gap-2 px-5 py-8 text-sm text-ink-400 sm:flex-row sm:items-center sm:justify-between">
                <p>Catering Marketplace · Laravel + PostgreSQL + Vue</p>
                <p>Built for offices and local caterers.</p>
            </div>
        </footer>
    </div>
</template>
