<script lang="ts">
	import { Home, Newspaper, Download } from 'lucide-svelte';

	const routes: Record<string, [string, any]> = {
		'/': ['Home', Home],
		'/blog': ['Blog', Newspaper],
		'/downloads': ['Downloads', Download],
		'/about': ['About', null]
	};
</script>

<section class="flex justify-between">
	<h2 class="text-3xl">Spotube</h2>
	<nav class="flex gap-3">
		{#each Object.entries(routes) as route}
			<a href={route[0]}>
				<button
					class={`btn rounded-full flex gap-2 ${route[0] === '/downloads' ? 'variant-glass-primary' : 'variant-glass-surface'}`}
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
