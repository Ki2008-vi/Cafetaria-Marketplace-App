import { reactive } from 'vue';

const state = reactive({
    isOpen: false,
    title: 'Konfirmasi Tindakan',
    message: '',
    confirmText: 'Ya, Lanjutkan',
    cancelText: 'Batal',
    type: 'danger', // 'danger' | 'warning' | 'info'
    resolve: null,
});

export function useConfirm() {
    function ask({
        title = 'Konfirmasi Tindakan',
        message = 'Apakah Anda yakin ingin melanjutkan tindakan ini?',
        confirmText = 'Ya, Lanjutkan',
        cancelText = 'Batal',
        type = 'danger',
    } = {}) {
        state.title = title;
        state.message = message;
        state.confirmText = confirmText;
        state.cancelText = cancelText;
        state.type = type;
        state.isOpen = true;

        return new Promise((resolve) => {
            state.resolve = resolve;
        });
    }

    function confirm() {
        state.isOpen = false;
        if (state.resolve) {
            state.resolve(true);
            state.resolve = null;
        }
    }

    function cancel() {
        state.isOpen = false;
        if (state.resolve) {
            state.resolve(false);
            state.resolve = null;
        }
    }

    return {
        state,
        ask,
        confirm,
        cancel,
    };
}
