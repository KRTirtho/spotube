<script lang="ts">
	import Layout from '$lib/components/markdown/layout.svelte';
	import type { PageData } from './$types';

	export let data: PageData;
	let {
		Content,
		meta: { date, title, readingTime }
	} = data as Required<PageData>;
</script>

<svelte:head>
	<title>Blog | {title}</title>
</svelte:head>

<article class="p-4 md:p-16 flex flex-grow flex-col">
	<h1 class="h1">{title}</h1>
	<br />
	<div class="">
		<p>{new Date(date).toDateString()}</p>
		<p class="mb-16">{readingTime?.text ?? ''}</p>
		<Layout>
			<svelte:component this={Content} />
		</Layout>
	</div>
</article>
