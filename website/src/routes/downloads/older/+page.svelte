<script lang="ts">
	import SvelteMarkdown from 'svelte-markdown';
	import type { PageData } from './$types';
	import { formatDistanceToNow, formatRelative } from 'date-fns';
	import Layout from '$lib/components/markdown/layout.svelte';
	import { Accordion, AccordionItem } from '@skeletonlabs/skeleton';
	import { Book, History } from 'lucide-svelte';
	import {
		faAndroid,
		faApple,
		faGit,
		faGooglePlay,
		faLinux,
		faWindows,
		type IconDefinition
	} from '@fortawesome/free-brands-svg-icons';
	import Fa from 'svelte-fa';
	import type { RestEndpointMethodTypes } from '@octokit/rest';

	export let data: PageData;

	function getIcon(assetUrl: string) {
		assetUrl = assetUrl.toLowerCase();
		if (assetUrl.includes('linux')) return faLinux;
		if (assetUrl.includes('windows')) return faWindows;
		if (assetUrl.includes('mac')) return faApple;
		if (assetUrl.includes('android')) return faAndroid;
		if (assetUrl.includes('playstore')) return faGooglePlay;
		if (assetUrl.includes('ios')) return faApple;

		return faGit;
	}

	function formatName(assetName: string) {
		// format the assetName to be
		// {OS} ({package extension})

		const lowerCasedAssetName = assetName.toLowerCase();
		const extension = assetName.split('.').at(-1);

		if (lowerCasedAssetName.includes('linux')) return [`Linux`, extension];
		if (lowerCasedAssetName.includes('windows')) return [`Windows`, extension];
		if (lowerCasedAssetName.includes('mac')) return [`macOS`, extension];
		if (lowerCasedAssetName.includes('android') || lowerCasedAssetName.includes('playstore'))
			return [`Android`, extension];
		if (lowerCasedAssetName.includes('ios')) return [`iOS`, extension];

		return [assetName.replace(`.${extension}`, ''), extension];
	}

	type OctokitAsset =
		RestEndpointMethodTypes['repos']['listReleases']['response']['data'][0]['assets'][0];

	function groupByOS(downloads: OctokitAsset[]) {
		return downloads.reduce(
			(acc, val) => {
				const lowName = val.name.toLowerCase();

				if (lowName.includes('android') || lowName.includes('playstore'))
					acc['android'] = [...(acc.android ?? []), val];
				if (lowName.includes('linux')) acc['linux'] = [...(acc['linux'] ?? []), val];
				if (lowName.includes('windows')) acc['windows'] = [...(acc['windows'] ?? []), val];
				if (lowName.includes('ios')) acc['ios'] = [...(acc['ios'] ?? []), val];
				if (lowName.includes('mac')) acc['mac'] = [...(acc['mac'] ?? []), val];

				return acc;
			},
			{} as Record<'android' | 'ios' | 'mac' | 'linux' | 'windows', OctokitAsset[]>
		);
	}

	const icons: Record<string, [IconDefinition, string]> = {
		android: [faAndroid, '#3DDC84'],
		mac: [faApple, ''],
		ios: [faApple, ''],
		linux: [faLinux, '#000000'],
		windows: [faWindows, '#0078D7']
	};
</script>

<div class="p-4 md:p-24">
	<div class="flex gap-2 items-center">
		<h2 class="h2">Older versions</h2>
		<History />
	</div>
	<br /><br />
	<Accordion>
		<div class="flex flex-col gap-5">
			{#each data.releases as release}
				<h4 class="h4" title={formatRelative(release.published_at ?? new Date(), new Date())}>
					{release.tag_name}
					<span class="text-sm font-normal">
						({formatDistanceToNow(release.published_at ?? new Date(), { addSuffix: true })})
					</span>
				</h4>
				<div class="flex flex-col gap-5">
					{#each Object.entries(groupByOS(release.assets)) as [osName, assets]}
						<div class="flex flex-col gap-4">
							<h5 class="h5 capitalize">
								<Fa class="inline" icon={icons[osName][0]} color={icons[osName][1]} />
								{osName}
							</h5>
							<div class="flex flex-wrap gap-4">
								{#each assets as asset}
									<a href={asset.browser_download_url}>
										<button class="btn variant-glass-primary rounded p-0 flex flex-col gap-2">
											<span class="bg-primary-500 rounded-t p-3 w-full">
												<Fa class="inline" icon={getIcon(asset.browser_download_url)} />
											</span>
											<span class="p-4">
												{formatName(asset.name)[0]}
												<span class="chip variant-ghost-error">
													{formatName(asset.name)[1]}
												</span>
											</span>
										</button>
									</a>
								{/each}
							</div>
						</div>
					{/each}
				</div>
				<AccordionItem>
					<svelte:fragment slot="lead">
						<Book />
					</svelte:fragment>
					<svelte:fragment slot="summary">Release Notes & Changelogs</svelte:fragment>
					<svelte:fragment slot="content">
						<Layout>
							<SvelteMarkdown source={release.body} />
						</Layout>
					</svelte:fragment>
				</AccordionItem>
				<hr />
			{/each}
		</div>
	</Accordion>
</div>
