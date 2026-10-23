import { createRouter, createWebHistory } from 'vue-router';
import { useAuth } from './stores/auth';

const routes = [
    { path: '/', name: 'home', component: () => import('./pages/LandingPage.vue') },
    { path: '/login', name: 'login', component: () => import('./pages/LoginPage.vue'), meta: { guest: true } },
    { path: '/register', name: 'register', component: () => import('./pages/RegisterPage.vue'), meta: { guest: true } },
    { path: '/caterers/:id', name: 'caterer.show', component: () => import('./pages/office/CatererPage.vue') },
    {
        path: '/merchant',
        name: 'merchant.dashboard',
        component: () => import('./pages/merchant/DashboardPage.vue'),
        meta: { requiresAuth: true, role: 'merchant' },
    },
    {
        path: '/merchant/menu',
        name: 'merchant.menu',
        component: () => import('./pages/merchant/MenuPage.vue'),
        meta: { requiresAuth: true, role: 'merchant' },
    },
    {
        path: '/office',
        name: 'office.browse',
        component: () => import('./pages/office/BrowsePage.vue'),
        meta: { requiresAuth: true, role: 'office' },
    },
    {
        path: '/office/cart',
        name: 'office.cart',
        component: () => import('./pages/office/CartPage.vue'),
        meta: { requiresAuth: true, role: 'office' },
    },
    {
        path: '/orders',
        name: 'orders',
        component: () => import('./pages/OrdersPage.vue'),
        meta: { requiresAuth: true },
    },
    {
        path: '/invoices',
        name: 'invoices',
        component: () => import('./pages/InvoicesPage.vue'),
        meta: { requiresAuth: true },
    },
    {
        path: '/invoices/:id',
        name: 'invoices.show',
        component: () => import('./pages/InvoiceDetailPage.vue'),
        meta: { requiresAuth: true },
    },
    {
        path: '/profile',
        name: 'profile',
        component: () => import('./pages/ProfilePage.vue'),
        meta: { requiresAuth: true },
    },
    { path: '/:pathMatch(.*)*', redirect: '/' },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
    scrollBehavior() {
        return { top: 0 };
    },
});

router.beforeEach(async (to) => {
    const auth = useAuth();
    await auth.bootstrap();

    if (to.meta.requiresAuth && !auth.state.user) {
        return { name: 'login', query: { redirect: to.fullPath } };
    }

    if (to.meta.role && auth.state.user && auth.state.user.role !== to.meta.role) {
        return auth.portalPath.value;
    }

    if (to.meta.guest && auth.state.user) {
        return auth.portalPath.value;
    }
});

export default router;
