<script lang="ts">
	import { onMount } from 'svelte';

	export let adSlot: number;
	export let adFormat: 'auto' | 'fluid';
	// biome-ignore lint/style/useConst: This is just props
	export let fullWidthResponsive = true;
	// biome-ignore lint/style/useConst: This is just props
	export let style = 'display:block';
	// biome-ignore lint/style/useConst: This is just props
	export let adLayout: 'in-article' | 'in-feed' | 'in-page' | undefined = undefined;
	// biome-ignore lint/style/useConst: This is just props
  export let adLayoutKey: string | undefined = undefined;

	const AD_CLIENT = 'ca-pub-6419300932495863';

	onMount(() => {
		// biome-ignore lint/suspicious/noAssignInExpressions: <explanation>
		(window.adsbygoogle = window.adsbygoogle || []).push({});
	});
</script>

<ins
	class="adsbygoogle"
	{style}
	data-ad-layout={adLayout}
	data-ad-client={AD_CLIENT}
	data-ad-slot={adSlot}
	data-ad-format={adFormat}
	data-full-width-responsive={fullWidthResponsive}
  data-ad-layout-key={adLayoutKey}
></ins>
