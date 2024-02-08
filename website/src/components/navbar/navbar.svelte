<script lang="ts">
	import { page } from '$app/stores';
	import { routes } from '$lib';
	import { faGithub } from '@fortawesome/free-brands-svg-icons';
	import { getDrawerStore } from '@skeletonlabs/skeleton';
	import { Menu } from 'lucide-svelte';
	import Fa from 'svelte-fa';

	const drawerStore = getDrawerStore();
</script>

<section class="flex justify-between">
	<div class="flex items-center justify-between w-full">
		<div class="flex items-center gap-2">
			<button
				class="btn btn-icon md:hidden"
				on:click={() => {
					drawerStore.set({ id: 'navdrawer', width: '400px', open: !$drawerStore.open });
				}}
			>
				<Menu />
			</button>
			<h2 class="text-3xl">Spotube</h2>
		</div>
		<a
			class="mw-2 md:me-4"
			href="https://github.com/KRTirtho/spotube?referrer=spotube.krtirtho.dev"
			target="_blank"
		>
			<button class="btn variant-filled flex items-center gap-2">
				<Fa icon={faGithub} />
				Star us on GitHub
			</button>
		</a>
	</div>
	<nav class="hidden md:flex gap-3">
		{#each Object.entries(routes) as route}
			<a href={route[0]}>
				<button
					class={`btn rounded-full flex gap-2 ${route[0] === '/downloads' ? 'variant-glass-primary' : 'variant-glass-surface'} ${$page.url.pathname.endsWith(route[0]) ? 'underline' : ''}`}
				>
					{#if route[1][1] !== null}
						<svelte:component this={route[1][1]} size={16} />
					{/if}
					{route[1][0]}
				</button>
			</a>
		{/each}
	</nav>
</section>
