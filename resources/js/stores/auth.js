import { computed, reactive } from 'vue';
import { api } from '../lib/api';

const state = reactive({
    user: null,
    ready: false,
});

let bootstrapped = false;

async function bootstrap() {
    if (bootstrapped) {
        return state.user;
    }

    try {
        const payload = await api.get('/me');
        state.user = payload.user;
    } catch {
        state.user = null;
    } finally {
        state.ready = true;
        bootstrapped = true;
    }

    return state.user;
}

async function login(credentials) {
    const payload = await api.post('/login', credentials);
    state.user = payload.user;

    return payload.user;
}

async function register(form) {
    const payload = await api.post('/register', form);
    state.user = payload.user;

    return payload.user;
}

async function logout() {
    try {
        await api.post('/logout');
    } finally {
        state.user = null;
        bootstrapped = true;
    }
}

function setUser(user) {
    state.user = user;
}

const isAuthenticated = computed(() => Boolean(state.user));
const isMerchant = computed(() => state.user?.role === 'merchant');
const isOffice = computed(() => state.user?.role === 'office');
const portalPath = computed(() => (state.user?.role === 'merchant' ? '/merchant' : '/office'));

export function useAuth() {
    return {
        state,
        isAuthenticated,
        isMerchant,
        isOffice,
        portalPath,
        bootstrap,
        login,
        register,
        logout,
        setUser,
    };
}
