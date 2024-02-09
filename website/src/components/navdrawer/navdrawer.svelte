<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { routes } from '$lib';
	import { ListBox, ListBoxItem, getDrawerStore } from '@skeletonlabs/skeleton';
	import { X } from 'lucide-svelte';
	import DarkmodeToggle from '../navbar/darkmode-toggle.svelte';

	let currentRoute: string = $page.url.pathname;
	const drawerStore = getDrawerStore();
</script>

<nav class="px-2">
	<div class="flex justify-end">
		<button class="btn btn-icon" on:click={drawerStore.close}>
			<X />
		</button>
	</div>
	<ListBox>
		{#each Object.entries(routes) as route}
			<ListBoxItem
				bind:group={currentRoute}
				name="item"
				value={route[0]}
				on:click={() => {
					goto(route[0]);
				}}
			>
				<div class="flex gap-2 items-center">
					<svelte:component this={route[1][1]} size={16} />
					{route[1][0]}
				</div>
			</ListBoxItem>
		{/each}
		<DarkmodeToggle label="Theme" />
	</ListBox>
</nav>
