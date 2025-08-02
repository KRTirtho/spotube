<script>
	import { AlertTriangle, Bug, Sparkles } from 'lucide-svelte';
	import DownloadItems from '$lib/components/downloads/download-items.svelte';
	import { ADS_SLOTS, extendedNightlyDownloadLinks } from '$lib';
	import Ads from '$lib/components/ads/ads.svelte';
</script>

<section class="p-4 md:p-16">
	<h2 class="h2 flex items-center gap-4">
		Nightly Downloads
		<Sparkles class="inline" size={30} />
	</h2>
	<br /><br />
	<aside class="alert variant-ghost-warning">
		<div><AlertTriangle class="text-warning-500" /></div>
		<div class="alert-message">
			<h3 class="h3">Nightly versions may contain bugs <Bug class="inline" /></h3>
			<p>
				Although Nightly versions are packed with newest and greatest features, it's often unstable
				and not tested by the maintainers and publisher(s).
				<br />
				<span class="text-error-500 underline decoration-dotted">
					So use it at your own risk.
				</span>
				<span>
					Go to <a href="/downloads" class="anchor">Downloads</a> for more stable releases.
				</span>
			</p>
		</div>
	</aside>
	<br />

	<p class="mb-4">Following are the new v5 Nightly versions:</p>
	<DownloadItems links={extendedNightlyDownloadLinks} />

	<br />
	<Ads adSlot={ADS_SLOTS.downloadPageDisplay} adFormat="auto" />
	<br />
</section>
