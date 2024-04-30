<script lang="ts">
	import type { PageData } from './$types';

	export let data: PageData;

	const formatter = Intl.DateTimeFormat('en-US', {
		dateStyle: 'medium'
	});
</script>

<section class="p-4 md:p-16 flex flex-col gap-4">
	<h2 class="h2">Blog Posts</h2>
	<br />
	<article class="grid sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4">
		{#each data.posts as post}
			<a
				href={`/blog/${post.slug}`}
				class="card hover:brightness-95 active:bg-secondary-hover-token active:scale-95 transition-all variant-ghost-secondary p-4"
			>
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
		{/each}
	</article>
</section>
