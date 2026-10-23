<script setup>
import { statusTone, titleCase } from '../lib/format';

defineProps({
    status: {
        type: String,
        required: true,
    },
});
</script>

<template>
    <span :class="statusTone(status)">{{ titleCase(status) }}</span>
</template>
