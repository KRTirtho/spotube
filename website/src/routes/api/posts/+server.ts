import { getPosts } from '$lib/posts';
import type { RequestHandler } from '@sveltejs/kit';
import { json } from '@sveltejs/kit';

export const GET: RequestHandler = async () => {
	const { posts } = await getPosts();

	return json(posts);
};
