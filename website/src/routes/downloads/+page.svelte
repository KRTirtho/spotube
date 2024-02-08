<script lang="ts">
	import { extendedDownloadLinks } from '$lib';
	import { Download } from 'lucide-svelte';
	import Fa from 'svelte-fa';
</script>

<section class="p-4 md:p-16">
	<h2 class="h2 flex items-center gap-4">
		Download
		<Download class="inline" size={30} />
	</h2>
	<br /><br />
	<h5 class="h5">Spotube is available for every platform</h5>
	<br />

	<div class="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
		{#each Object.entries(extendedDownloadLinks) as links}
			<a href={links[1][0]} class="flex flex-col btn variant-ghost-primary rounded-xl p-0">
				<div class="relative bg-primary-500 p-4 flex gap-4 justify-center rounded-t-xl w-full">
					{#each links[1][1] as icon}
						<Fa {icon} />
					{/each}
					<p class="chip variant-ghost-error text-error-400 absolute right-2 uppercase">
						{links[1][2]}
					</p>
				</div>
				<p class="p-4">{links[0]}</p>
			</a>
		{/each}
	</div>
</section>
