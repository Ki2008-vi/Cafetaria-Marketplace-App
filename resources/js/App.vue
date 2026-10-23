<script setup>
import { RouterLink, RouterView, useRouter, useRoute } from 'vue-router';
import { useAuth } from './stores/auth';
import { useCart } from './stores/cart';
import ConfirmModal from './components/ConfirmModal.vue';

const router = useRouter();
const route = useRoute();
const { state, isAuthenticated, isMerchant, isOffice, logout } = useAuth();
const { count, clear } = useCart();

async function signOut() {
    await logout();
    clear();
    router.push('/');
}

function isActive(path) {
    if (path === '/' && route.path === '/') return true;
    if (path !== '/' && route.path.startsWith(path)) return true;
    return false;
}
</script>

<template>
    <div class="flex min-h-screen flex-col bg-[#FAF7F2] text-stone-900 antialiased font-sans">
        <!-- Floating Modern Header (GoFoddie / Bell Inspired) -->
        <header class="sticky top-0 z-40 border-b border-stone-200/80 bg-[#FAF7F2]/85 backdrop-blur-md">
            <div class="mx-auto flex max-w-6xl items-center justify-between gap-4 px-5 py-3.5">
                <!-- Brand Logo -->
                <RouterLink to="/" class="group flex items-center gap-3">
                    <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-stone-900 text-amber-400 shadow-sm transition group-hover:scale-105 group-hover:bg-stone-800">
                        <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                            <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                            <line x1="6" y1="1" x2="6" y2="4"></line>
                            <line x1="10" y1="1" x2="10" y2="4"></line>
                            <line x1="14" y1="1" x2="14" y2="4"></line>
                        </svg>
                    </div>
                    <div>
                        <div class="flex items-center gap-1.5 font-display text-lg font-bold tracking-tight text-stone-900">
                            <span>Go</span><span class="text-amber-500">Catering</span>
                        </div>
                        
                    </div>
                </RouterLink>

                <!-- Navigation Links -->
                <nav class="flex flex-wrap items-center gap-1.5 text-xs font-semibold">
                    <RouterLink
                        to="/"
                        class="rounded-full px-3.5 py-2 transition"
                        :class="isActive('/') && route.path === '/' ? 'bg-stone-900 text-white shadow-xs' : 'text-stone-600 hover:bg-stone-200/50 hover:text-stone-900'"
                    >
                        Home
                    </RouterLink>

                    <template v-if="isOffice">
                        <RouterLink
                            to="/office"
                            class="rounded-full px-3.5 py-2 transition"
                            :class="isActive('/office') && route.path !== '/office/cart' ? 'bg-stone-900 text-white shadow-xs' : 'text-stone-600 hover:bg-stone-200/50 hover:text-stone-900'"
                        >
                            Cari Katering
                        </RouterLink>
                        <RouterLink
                            to="/orders"
                            class="rounded-full px-3.5 py-2 transition"
                            :class="isActive('/orders') ? 'bg-stone-900 text-white shadow-xs' : 'text-stone-600 hover:bg-stone-200/50 hover:text-stone-900'"
                        >
                            Pesanan Tim
                        </RouterLink>
                        <RouterLink
                            to="/invoices"
                            class="rounded-full px-3.5 py-2 transition"
                            :class="isActive('/invoices') ? 'bg-stone-900 text-white shadow-xs' : 'text-stone-600 hover:bg-stone-200/50 hover:text-stone-900'"
                        >
                            Tagihan / Invoices
                        </RouterLink>
                    </template>

                    <template v-if="isMerchant">
                        <RouterLink
                            to="/merchant"
                            class="rounded-full px-3.5 py-2 transition"
                            :class="isActive('/merchant') && route.path === '/merchant' ? 'bg-stone-900 text-white shadow-xs' : 'text-stone-600 hover:bg-stone-200/50 hover:text-stone-900'"
                        >
                            Dashboard Dapur
                        </RouterLink>
                        <RouterLink
                            to="/merchant/menu"
                            class="rounded-full px-3.5 py-2 transition"
                            :class="isActive('/merchant/menu') ? 'bg-stone-900 text-white shadow-xs' : 'text-stone-600 hover:bg-stone-200/50 hover:text-stone-900'"
                        >
                            Kelola Menu
                        </RouterLink>
                        <RouterLink
                            to="/orders"
                            class="rounded-full px-3.5 py-2 transition"
                            :class="isActive('/orders') ? 'bg-stone-900 text-white shadow-xs' : 'text-stone-600 hover:bg-stone-200/50 hover:text-stone-900'"
                        >
                            Pesanan Masuk
                        </RouterLink>
                        <RouterLink
                            to="/invoices"
                            class="rounded-full px-3.5 py-2 transition"
                            :class="isActive('/invoices') ? 'bg-stone-900 text-white shadow-xs' : 'text-stone-600 hover:bg-stone-200/50 hover:text-stone-900'"
                        >
                            Faktur
                        </RouterLink>
                    </template>

                    <!-- Cart Indicator (Bell-style Pill) -->
                    <RouterLink
                        v-if="isOffice"
                        to="/office/cart"
                        class="relative flex items-center gap-1.5 rounded-full border border-stone-200 bg-white px-3.5 py-1.5 text-xs font-semibold text-stone-800 shadow-xs transition hover:border-stone-300 hover:bg-stone-50"
                    >
                        <svg class="h-3.5 w-3.5 text-stone-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4H6z"></path>
                            <line x1="3" y1="6" x2="21" y2="6"></line>
                            <path d="M16 10a4 4 0 01-8 0"></path>
                        </svg>
                        <span>Keranjang</span>
                        <span
                            v-if="count"
                            class="ml-0.5 inline-flex h-4 min-w-4 items-center justify-center rounded-full bg-amber-500 px-1 text-[10px] font-bold text-stone-950 shadow-xs"
                        >
                            {{ count }}
                        </span>
                    </RouterLink>

                    <!-- User Profile / Auth State -->
                    <div class="ml-2 flex items-center gap-2 border-l border-stone-200 pl-3">
                        <template v-if="isAuthenticated">
                            <RouterLink
                                to="/profile"
                                class="flex items-center gap-2 rounded-full border border-stone-200 bg-white py-1 pl-1.5 pr-3 shadow-xs hover:border-stone-300 transition"
                            >
                                <span class="flex h-6 w-6 items-center justify-center rounded-full bg-amber-100 text-xs font-bold text-amber-800">
                                    {{ state.user.company_name?.charAt(0) || 'U' }}
                                </span>
                                <span class="max-w-[120px] truncate text-xs font-semibold text-stone-800">
                                    {{ state.user.company_name }}
                                </span>
                            </RouterLink>
                            <button
                                type="button"
                                class="rounded-full px-2.5 py-1.5 text-xs text-stone-500 hover:text-stone-900 transition"
                                @click="signOut"
                            >
                                Keluar
                            </button>
                        </template>

                        <template v-else>
                            <RouterLink
                                to="/login"
                                class="rounded-full px-3 py-1.5 text-xs font-semibold text-stone-600 hover:text-stone-900 transition"
                            >
                                Masuk
                            </RouterLink>
                            <RouterLink
                                to="/register"
                                class="rounded-full bg-stone-900 px-4 py-2 text-xs font-semibold text-white shadow-sm transition hover:bg-stone-800 active:scale-95"
                            >
                                Daftar Gratis
                            </RouterLink>
                        </template>
                    </div>
                </nav>
            </div>
        </header>

        <!-- Main Content View -->
        <main class="flex-1">
            <RouterView />
        </main>

        <!-- Modern Footer -->
        <footer class="border-t border-stone-200/80 bg-white/60">
            <div class="mx-auto max-w-6xl px-6 py-12">
                <div class="grid gap-8 md:grid-cols-4">
                    <div class="md:col-span-2">
                        <div class="flex items-center gap-2.5 font-display text-xl font-bold tracking-tight text-stone-900">
                            <div class="flex h-8 w-8 items-center justify-center rounded-xl bg-stone-900 text-amber-400">
                                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                                    <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                                </svg>
                            </div>
                            <span>Go<span class="text-amber-500">Catering</span></span>
                        </div>
                        <p class="mt-3 max-w-sm text-xs leading-relaxed text-stone-500">
                            Marketplace katering B2B pertama yang memudahkan perusahaan mengelola makan siang harian, event, dan konsolidasi invoice dengan ratusan dapur lokal terpercaya.
                        </p>
                        <div class="mt-4 flex items-center gap-2 text-xs text-stone-400">
                            <span class="inline-block h-2 w-2 rounded-full bg-emerald-500"></span>
                            <span>Melayani Jakarta, Tangerang, Surabaya, & Bandung</span>
                        </div>
                    </div>

                    <div>
                        <h4 class="text-xs font-bold uppercase tracking-wider text-stone-900">Untuk Kantor</h4>
                        <ul class="mt-3 space-y-2 text-xs text-stone-600">
                            <li><RouterLink to="/office" class="hover:text-stone-900">Katalog Dapur Katering</RouterLink></li>
                            <li><RouterLink to="/register" class="hover:text-stone-900">Daftar Akun Kantor</RouterLink></li>
                            <li><span class="text-stone-400">Katering Langganan Mingguan</span></li>
                            <li><span class="text-stone-400">Konsolidasi Faktur Pajak</span></li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="text-xs font-bold uppercase tracking-wider text-stone-900">Untuk Mitra Vendor</h4>
                        <ul class="mt-3 space-y-2 text-xs text-stone-600">
                            <li><RouterLink to="/register" class="hover:text-stone-900">Gabung Mitra Katering</RouterLink></li>
                            <li><RouterLink to="/login" class="hover:text-stone-900">Portal Vendor Dapur</RouterLink></li>
                            <li><span class="text-stone-400">Standar Higienis & Halal</span></li>
                            <li><span class="text-stone-400">Bantuan & Edukasi Menu</span></li>
                        </ul>
                    </div>
                </div>

                <div class="mt-12 flex flex-col items-center justify-between gap-4 border-t border-stone-100 pt-6 text-xs text-stone-400 sm:flex-row">
                    <p>© {{ new Date().getFullYear() }} GoCatering Marketplace. All rights reserved.</p>
                    <div class="flex gap-4">
                        <span class="hover:text-stone-600 cursor-pointer">Kebijakan Privasi</span>
                        <span>·</span>
                        <span class="hover:text-stone-600 cursor-pointer">Syarat & Ketentuan</span>
                        <span>·</span>
                        <span class="hover:text-stone-600 cursor-pointer">Hubungi Kami</span>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Global Accessible Confirm & Warning Modal -->
        <ConfirmModal />
    </div>
</template>
