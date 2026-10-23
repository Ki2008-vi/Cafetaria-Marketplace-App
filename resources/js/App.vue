<script setup>
import { ref } from 'vue';
import { RouterLink, RouterView, useRouter, useRoute } from 'vue-router';
import { useAuth } from './stores/auth';
import { useCart } from './stores/cart';
import ConfirmModal from './components/ConfirmModal.vue';

const router = useRouter();
const route = useRoute();
const { state, isAuthenticated, isMerchant, isOffice, logout } = useAuth();
const { count, clear } = useCart();

const mobileMenuOpen = ref(false);

router.afterEach(() => {
    mobileMenuOpen.value = false;
});

async function signOut() {
    mobileMenuOpen.value = false;
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
    <div class="flex min-h-screen flex-col bg-[#FAF7F2] text-stone-900 antialiased font-sans overflow-x-clip">
        <!-- Floating Modern Header (GoFoddie / Bell Inspired) -->
        <header class="no-print print:hidden sticky top-0 z-40 border-b border-stone-200/80 bg-[#FAF7F2]/90 backdrop-blur-md">
            <div class="mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 sm:px-6 py-3">
                <!-- Brand Logo -->
                <RouterLink to="/" class="group flex items-center gap-2.5">
                    <div class="flex h-9 w-9 sm:h-10 sm:w-10 items-center justify-center rounded-2xl bg-stone-900 text-amber-400 shadow-sm transition group-hover:scale-105 group-hover:bg-stone-800">
                        <svg class="h-4 w-4 sm:h-5 sm:w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                            <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                            <line x1="6" y1="1" x2="6" y2="4"></line>
                            <line x1="10" y1="1" x2="10" y2="4"></line>
                            <line x1="14" y1="1" x2="14" y2="4"></line>
                        </svg>
                    </div>
                    <div>
                        <div class="flex items-center gap-1 font-display text-base sm:text-lg font-black tracking-tight text-stone-900">
                            <span>Go</span><span class="text-amber-500">Catering</span>
                        </div>
                    </div>
                </RouterLink>

                <!-- Desktop Navigation Links (hidden on mobile) -->
                <nav class="hidden md:flex items-center gap-1.5 text-xs font-semibold">
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

                <!-- Mobile Action Area (< md) -->
                <div class="flex items-center gap-2 md:hidden">
                    <!-- Mobile Cart Pill if Office -->
                    <RouterLink
                        v-if="isOffice"
                        to="/office/cart"
                        class="relative flex items-center justify-center h-9 w-9 rounded-full border border-stone-200 bg-white shadow-xs"
                        aria-label="Keranjang Belanja"
                    >
                        <svg class="h-4 w-4 text-stone-700" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4H6z"></path>
                            <line x1="3" y1="6" x2="21" y2="6"></line>
                            <path d="M16 10a4 4 0 01-8 0"></path>
                        </svg>
                        <span
                            v-if="count"
                            class="absolute -top-1 -right-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-amber-500 px-1 text-[9px] font-bold text-stone-950"
                        >
                            {{ count }}
                        </span>
                    </RouterLink>

                    <!-- Hamburger Button -->
                    <button
                        type="button"
                        class="flex h-9 w-9 items-center justify-center rounded-2xl border border-stone-200 bg-white text-stone-700 shadow-xs hover:bg-stone-50 transition"
                        @click="mobileMenuOpen = !mobileMenuOpen"
                        :aria-expanded="mobileMenuOpen"
                        aria-label="Buka menu navigasi"
                    >
                        <!-- Close Icon when open -->
                        <svg v-if="mobileMenuOpen" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                        <!-- Hamburger Bars when closed -->
                        <svg v-else class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="3" y1="6" x2="21" y2="6"></line>
                            <line x1="3" y1="12" x2="21" y2="12"></line>
                            <line x1="3" y1="18" x2="21" y2="18"></line>
                        </svg>
                    </button>
                </div>
            </div>

            <!-- Mobile Slide-down Drawer Menu -->
            <div
                v-if="mobileMenuOpen"
                class="border-t border-stone-200 bg-[#FAF7F2] px-5 py-5 shadow-lg md:hidden animate-in slide-in-from-top-2 duration-200"
            >
                <div class="space-y-1 pb-4 border-b border-stone-200/80">
                    <RouterLink
                        to="/"
                        class="flex items-center gap-2 rounded-xl px-3.5 py-2.5 text-sm font-semibold transition"
                        :class="isActive('/') && route.path === '/' ? 'bg-stone-900 text-white' : 'text-stone-700 hover:bg-stone-100'"
                    >
                        <span>🏠</span>
                        <span>Home</span>
                    </RouterLink>

                    <template v-if="isOffice">
                        <RouterLink
                            to="/office"
                            class="flex items-center gap-2 rounded-xl px-3.5 py-2.5 text-sm font-semibold transition"
                            :class="isActive('/office') && route.path !== '/office/cart' ? 'bg-stone-900 text-white' : 'text-stone-700 hover:bg-stone-100'"
                        >
                            <span>🍲</span>
                            <span>Cari Katering</span>
                        </RouterLink>
                        <RouterLink
                            to="/orders"
                            class="flex items-center gap-2 rounded-xl px-3.5 py-2.5 text-sm font-semibold transition"
                            :class="isActive('/orders') ? 'bg-stone-900 text-white' : 'text-stone-700 hover:bg-stone-100'"
                        >
                            <span>📦</span>
                            <span>Pesanan Tim</span>
                        </RouterLink>
                        <RouterLink
                            to="/invoices"
                            class="flex items-center gap-2 rounded-xl px-3.5 py-2.5 text-sm font-semibold transition"
                            :class="isActive('/invoices') ? 'bg-stone-900 text-white' : 'text-stone-700 hover:bg-stone-100'"
                        >
                            <span>🧾</span>
                            <span>Tagihan / Invoices</span>
                        </RouterLink>
                    </template>

                    <template v-if="isMerchant">
                        <RouterLink
                            to="/merchant"
                            class="flex items-center gap-2 rounded-xl px-3.5 py-2.5 text-sm font-semibold transition"
                            :class="isActive('/merchant') && route.path === '/merchant' ? 'bg-stone-900 text-white' : 'text-stone-700 hover:bg-stone-100'"
                        >
                            <span>📊</span>
                            <span>Dashboard Dapur</span>
                        </RouterLink>
                        <RouterLink
                            to="/merchant/menu"
                            class="flex items-center gap-2 rounded-xl px-3.5 py-2.5 text-sm font-semibold transition"
                            :class="isActive('/merchant/menu') ? 'bg-stone-900 text-white' : 'text-stone-700 hover:bg-stone-100'"
                        >
                            <span>🍽️</span>
                            <span>Kelola Menu</span>
                        </RouterLink>
                        <RouterLink
                            to="/orders"
                            class="flex items-center gap-2 rounded-xl px-3.5 py-2.5 text-sm font-semibold transition"
                            :class="isActive('/orders') ? 'bg-stone-900 text-white' : 'text-stone-700 hover:bg-stone-100'"
                        >
                            <span>📦</span>
                            <span>Pesanan Masuk</span>
                        </RouterLink>
                        <RouterLink
                            to="/invoices"
                            class="flex items-center gap-2 rounded-xl px-3.5 py-2.5 text-sm font-semibold transition"
                            :class="isActive('/invoices') ? 'bg-stone-900 text-white' : 'text-stone-700 hover:bg-stone-100'"
                        >
                            <span>🧾</span>
                            <span>Faktur Invoice</span>
                        </RouterLink>
                    </template>
                </div>

                <!-- Mobile Auth Area -->
                <div class="pt-4">
                    <template v-if="isAuthenticated">
                        <div class="mb-3 flex items-center justify-between rounded-2xl bg-white p-3 border border-stone-200/80 shadow-2xs">
                            <div class="flex items-center gap-2.5 min-w-0">
                                <span class="flex h-8 w-8 items-center justify-center rounded-xl bg-amber-100 text-xs font-bold text-amber-800 shrink-0">
                                    {{ state.user.company_name?.charAt(0) || 'U' }}
                                </span>
                                <div class="min-w-0">
                                    <p class="truncate text-xs font-bold text-stone-900">{{ state.user.company_name }}</p>
                                    <p class="text-[10px] text-stone-400 capitalize">{{ state.user.role }} Account</p>
                                </div>
                            </div>
                            <RouterLink
                                to="/profile"
                                class="rounded-full border border-stone-200 px-3 py-1 text-xs font-semibold text-stone-700 hover:bg-stone-50"
                            >
                                Profil
                            </RouterLink>
                        </div>
                        <button
                            type="button"
                            class="w-full rounded-2xl border border-red-200 bg-red-50 py-2.5 text-xs font-semibold text-red-700 hover:bg-red-100 transition"
                            @click="signOut"
                        >
                            Keluar dari Akun
                        </button>
                    </template>

                    <template v-else>
                        <div class="grid grid-cols-2 gap-2">
                            <RouterLink
                                to="/login"
                                class="flex items-center justify-center rounded-2xl border border-stone-200 bg-white py-2.5 text-xs font-bold text-stone-800 shadow-2xs"
                            >
                                Masuk
                            </RouterLink>
                            <RouterLink
                                to="/register"
                                class="flex items-center justify-center rounded-2xl bg-stone-900 py-2.5 text-xs font-bold text-white shadow-xs"
                            >
                                Daftar Gratis
                            </RouterLink>
                        </div>
                    </template>
                </div>
            </div>
        </header>

        <!-- Main Content View -->
        <main class="flex-1">
            <RouterView />
        </main>

        <!-- Modern Responsive Footer -->
        <footer class="no-print print:hidden border-t border-stone-200/80 bg-white/60">
            <div class="mx-auto max-w-6xl px-5 sm:px-6 py-10 sm:py-12">
                <div class="grid gap-8 sm:grid-cols-2 md:grid-cols-4">
                    <div class="sm:col-span-2">
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

                <div class="mt-10 sm:mt-12 flex flex-col items-center justify-between gap-4 border-t border-stone-100 pt-6 text-xs text-stone-400 sm:flex-row">
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
