<script setup>
import { onMounted, onUnmounted } from 'vue';
import { useConfirm } from '../stores/confirm';

const { state, confirm, cancel } = useConfirm();

function handleKeydown(e) {
    if (state.isOpen && e.key === 'Escape') {
        cancel();
    }
}

onMounted(() => {
    window.addEventListener('keydown', handleKeydown);
});

onUnmounted(() => {
    window.removeEventListener('keydown', handleKeydown);
});
</script>

<template>
    <Teleport to="body">
        <Transition
            enter-active-class="transition duration-200 ease-out"
            enter-from-class="opacity-0"
            enter-to-class="opacity-100"
            leave-active-class="transition duration-150 ease-in"
            leave-from-class="opacity-100"
            leave-to-class="opacity-0"
        >
            <div
                v-if="state.isOpen"
                class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-stone-950/60 backdrop-blur-xs"
                @click.self="cancel"
                role="dialog"
                aria-modal="true"
                aria-labelledby="confirm-dialog-title"
                aria-describedby="confirm-dialog-desc"
            >
                <div
                    class="relative w-full max-w-md transform overflow-hidden rounded-3xl border border-stone-200/90 bg-white p-6 shadow-2xl transition-all sm:p-7"
                    @click.stop
                >
                    <!-- Close button in top right -->
                    <button
                        type="button"
                        class="absolute right-4 top-4 rounded-full p-1.5 text-stone-400 hover:bg-stone-100 hover:text-stone-700 transition"
                        @click="cancel"
                        aria-label="Tutup dialog"
                    >
                        <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>

                    <div class="flex items-start gap-4">
                        <!-- Icon Badge -->
                        <div
                            class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl"
                            :class="{
                                'bg-red-50 text-red-600 border border-red-200': state.type === 'danger',
                                'bg-amber-50 text-amber-600 border border-amber-200': state.type === 'warning',
                                'bg-emerald-50 text-emerald-600 border border-emerald-200': state.type === 'info',
                            }"
                        >
                            <!-- Danger Icon -->
                            <svg v-if="state.type === 'danger'" class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 6h18"></path>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                <line x1="10" y1="11" x2="10" y2="17"></line>
                                <line x1="14" y1="11" x2="14" y2="17"></line>
                            </svg>

                            <!-- Warning Icon -->
                            <svg v-else-if="state.type === 'warning'" class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                                <line x1="12" y1="9" x2="12" y2="13"></line>
                                <line x1="12" y1="17" x2="12.01" y2="17"></line>
                            </svg>

                            <!-- Info / Success Icon -->
                            <svg v-else class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                        </div>

                        <!-- Content -->
                        <div class="flex-1 pr-4">
                            <h3 id="confirm-dialog-title" class="font-display text-lg font-bold text-stone-900 leading-snug">
                                {{ state.title }}
                            </h3>
                            <p id="confirm-dialog-desc" class="mt-2 text-xs leading-relaxed text-stone-600 sm:text-sm">
                                {{ state.message }}
                            </p>
                        </div>
                    </div>

                    <!-- Footer Actions -->
                    <div class="mt-7 flex items-center justify-end gap-2.5 border-t border-stone-100 pt-4">
                        <button
                            type="button"
                            class="rounded-full border border-stone-200 bg-white px-5 py-2.5 text-xs font-semibold text-stone-700 shadow-2xs hover:bg-stone-50 hover:border-stone-300 transition focus:outline-none focus-visible:ring-2 focus-visible:ring-stone-400"
                            @click="cancel"
                        >
                            {{ state.cancelText }}
                        </button>

                        <button
                            type="button"
                            class="rounded-full px-5 py-2.5 text-xs font-bold shadow-xs transition active:scale-95 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
                            :class="{
                                'bg-red-600 text-white hover:bg-red-700 focus-visible:ring-red-600': state.type === 'danger',
                                'bg-amber-500 text-stone-950 hover:bg-amber-400 focus-visible:ring-amber-500': state.type === 'warning',
                                'bg-stone-900 text-white hover:bg-stone-800 focus-visible:ring-stone-900': state.type === 'info',
                            }"
                            @click="confirm"
                        >
                            {{ state.confirmText }}
                        </button>
                    </div>
                </div>
            </div>
        </Transition>
    </Teleport>
</template>
