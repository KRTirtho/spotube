<script lang="ts">
	import { SlideToggle } from '@skeletonlabs/skeleton';
	import { persisted } from '$lib/persisted-store';
	import { browser } from '$app/environment';

	export const isDark = persisted('dark-mode', false);

	$: {
		if (browser) {
			$isDark
				? document.documentElement.classList.add('dark')
				: document.documentElement.classList.remove('dark');
		}
	}

	export let label: string | undefined;
</script>

<div class="inline-flex gap-2">
	<SlideToggle
    label={label}
		active="bg-primary-backdrop-token"
		size="sm"
		name="dark-mode"
		checked={$isDark}
		on:change={() => {
			isDark.update((prev) => !prev);
		}}
	/>
</div>
