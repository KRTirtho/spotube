<script lang="ts">
	import Layout from '$lib/components/markdown/layout.svelte';
	import type { PageData } from './$types';

	export let data: PageData;
	const {
		Content,
		meta: { date, title, readingTime, cover_img, author }
	} = data as Required<PageData>;
</script>

<svelte:head>
	<title>Blog | {title}</title>
</svelte:head>

<article class="p-4 md:p-16">
	<section
		class={cover_img
			? 'bg-black/30 h-56 md:h-80 xl:h-96 bg-cover bg-center flex flex-col justify-end p-4 pb-0 md:p-8 md:pb-0 rounded-lg'
			: null}
		style={cover_img ? `background-image: url(/posts/${cover_img});` : ''}
	>
		<h1 class={`h1 text-stroke ${cover_img ? 'text-white' : ''}`}>{title}</h1>
		<h4 class={`h4 text-stroke text-gray-400`}>By {author}</h4>
		<br />
		<p class={cover_img ? 'text-gray-400' : ''}>{new Date(date).toDateString()}</p>
		<p class={`mb-16 ${cover_img ? 'text-gray-400' : ''}`}>{readingTime?.text ?? ''}</p>
	</section>
	<br />
	<Layout>
		<svelte:component this={Content} />
	</Layout>
</article>
