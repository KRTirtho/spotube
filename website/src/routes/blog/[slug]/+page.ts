import type { Post } from '$lib/posts.js';

export const load = async ({ params }) => {
	const { slug } = params;

	try {
		const post = await import(`../../../../posts/${slug}.md`);
		return {
			Content: post.default as ConstructorOfATypedSvelteComponent,
			meta: {
				...post.metadata,
				slug,
				path: `/blog/${slug}`
			} as Post
		};
	} catch (err) {
		console.error('Error loading the post:', err);
		return {
			status: 500,
			error: `Could not load the post: ${(err as Error).message || err}`
		};
	}
};
