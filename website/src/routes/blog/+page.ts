import type { Post } from "$lib/posts.js";

export const load = async ({ fetch }) => {
	const res = await fetch("api/posts");
	if (res.ok) {
		const posts: Post[] = await res.json();
		return { posts };
	}
	return { posts: [] };
};
