<script lang="ts">
	import SvelteMarkdown from 'svelte-markdown';
	import Layout from '$lib/components/markdown/layout.svelte';
	import { X } from 'lucide-svelte';
	import { getModalStore } from '@skeletonlabs/skeleton';

	const modalStore = getModalStore();

	const mdContent = `
## Spotube reborn 🦄

After facing a legal threat(s) from Spotify™, Spotube has moved from using Spotify™ API for music metadata purposes.
Now we're aiming to make Spotube an extensible music streaming platform and will continue to use free to use and open source music APIs.

So users can bring their own metadata APIs (already finished) and playback APIs (WIP). And can plug things together using community plugins.

To reduce friction, by default, from Spotube v5, it will contain MusicBrainz and ListenBrainz plugin (including support for custom instances). But you can always
bring your own metadata and playback APIs using plugins (there will be documentation on how to do that soon!).

Currently, the v5 is still under beta. So only nightly builds are downloadable. Please continue to use Nightly versions (it can contains bugs or not work at all) until stable Spotube v5 is released.

Btw, please support the [MetaBrainz Foundation](https://metabrainz.org/) for their amazing work on MusicBrainz and ListenBrainz.
They're open source and non-profit, so they need your support to keep the lights on and continue their work.
`;
</script>

<div class="bg-primary-100 p-5 rounded-lg overflow-scroll max-h-[95vh] relative">
	<button
		type="button"
		class="btn variant-soft absolute top-2 right-2"
		on:click={() => modalStore.close()}
	>
		<X />
	</button>
	<Layout>
		<SvelteMarkdown source={mdContent} />
	</Layout>

	<p class="text-surface-500 mt-5">
		Spotube has no affiliation with Spotify™ or any of its subsidiaries.
	</p>
	<div class="flex justify-end mt-4">
		<button type="button" class="btn variant-filled-primary" on:click={() => modalStore.close()}>
			Understood
		</button>
	</div>
</div>
