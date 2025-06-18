<script lang="ts">
	// import { ADS_SLOTS, extendedDownloadLinks } from '$lib';
	import { Download } from 'lucide-svelte';
	// import { History, Sparkles, Package } from 'lucide-svelte';
	// import DownloadItems from '$lib/components/downloads/download-items.svelte';
	// import Ads from '$lib/components/ads/ads.svelte';

	// const otherDownloads: [string, string, any][] = [
		// ['/downloads/packages', 'CLI Packages Managers', Package],
		// ['/downloads/older', 'Older Versions', History],
		// ['/downloads/nightly', 'Nightly Builds', Sparkles]
	// ];
</script>

<section class="p-4 md:p-16 md:pb-4">
	<h2 class="h2 flex items-center gap-4">
		Download
		<Download class="inline" size={30} />
	</h2>
	<br /><br />
	<h5 class="h5">Spotube is available for every platform</h5>
	<br />

	<!-- <DownloadItems links={extendedDownloadLinks} /> -->

	<h3 class="h3 text-red-500">
		Versions of Spotube (&lt;=v4.0.2) are ceased to work with Spotify™ API. 
		<br />
		So users can no longer use/download those versions. 
		<br />
		Please wait for the next version that will remedy this issue by not using such APIs.
	</h3>

	<p class="text-surface-500 mt-20">
		Spotube has no affiliation with Spotify™ or any of its subsidiaries.
	</p>

	<br />
	<!-- <Ads adSlot={ADS_SLOTS.downloadPageDisplay} adFormat="auto" /> -->
	<br />

	<!-- <h2 class="h2">Other Downloads</h2>
	<br /><br />
	<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2 max-w-3xl">
		{#each otherDownloads as download}
			<a href={download[0]}>
				<div class="btn rounded variant-soft-secondary flex flex-col items-center p-4 gap-4">
					<svelte:component this={download[2]} />
					<h5 class="h5">{download[1]}</h5>
				</div>
			</a>
		{/each}
	</div>
	<br /> -->
	<!-- <Ads adSlot={ADS_SLOTS.downloadPageDisplay} adFormat="auto" /> -->
</section>
