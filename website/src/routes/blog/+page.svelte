<script lang="ts">
	import { ADS_SLOTS } from '$lib';
	import Ads from '$lib/components/ads/ads.svelte';
	import type { Post } from '$lib/posts';
	import type { PageData } from './$types';

	export let data: PageData;

	const formatter = Intl.DateTimeFormat('en-US', {
		dateStyle: 'medium'
	});

	// insert a special Post as ad type in the posts array
	const adAddedPosts: Post[] = [];

	for (const post of data.posts) {
		adAddedPosts.push(post);
		const index = adAddedPosts.indexOf(post);

		if (index % 3 === 0) {
			adAddedPosts.push({
				title: 'Ad',
				author: 'Ad',
				cover_img: 'ad.jpg',
				date: new Date().toISOString(),
				path: '/ad',
				preview: 'Ad',
				preview_html: 'Ad',
				previewHtml: 'Ad',
				published: true,
				reading_time_text: 'Ad',
				readingTime: { minutes: 1, words: 1, text: 'Ad', time: 1 },
				slug: 'ad',
				tags: ['Ad']
			});
		}
	}
</script>

<section class="p-4 md:p-16 flex flex-col gap-4">
	<h2 class="h2">Blog Posts</h2>
	<br />
	<article class="grid sm:grid-cols-2 md:grid-cols-3 2xl:grid-cols-4">
		{#each adAddedPosts as post}
			{#if post.slug === 'ad'}
				<Ads
					adSlot={ADS_SLOTS.blogPageInFeed}
					adFormat="fluid"
					adLayoutKey="-6l+eh+17-40+59"
					fullWidthResponsive={false}
				/>
			{:else}
				<a
					href={`/blog/${post.slug}`}
					class="card hover:brightness-95 active:bg-secondary-hover-token active:scale-95 transition-all variant-ghost-secondary p-4"
				>
					<img
						src={`/posts/${post.cover_img}`}
						alt={post.title}
						class="rounded h-56 w-full object-cover"
					/>
					<h4 class="h4">{post.title}</h4>
					<p>By {post.author}</p>
					<br />
					<p class="text-end">
						Published on
						<span class="font-medium underline decoration-dotted">
							{formatter.format(new Date(post.date))}
						</span>
					</p>
				</a>
			{/if}
		{/each}
	</article>
</section>
