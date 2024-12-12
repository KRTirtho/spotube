export interface Post {
	date: string;
	title: string;
	tags: string[];
	published: boolean;
	author: string;
  cover_img: string | null;
	readingTime: {
		text: string;
		minutes: number;
		time: number;
		words: number;
	};
	reading_time_text: string;
	preview_html: string;
	preview: string;
	previewHtml: string;
	slug: string | null;
	path: string;
}

export const getPosts = async () => {
	// Fetch posts from local Markdown files
	const posts: Post[] = await Promise.all(
		Object.entries(import.meta.glob("../../posts/**/*.md")).map(
			async ([path, resolver]) => {
				const resolved = (await resolver()) as { metadata: Post };
				const { metadata } = resolved;
				const slug = path.split("/").pop()?.slice(0, -3) ?? "";
				return { ...metadata, slug };
			},
		),
	).then((posts) => posts.filter((post) => post.published));

	let sortedPosts = posts.sort((a, b) => +new Date(b.date) - +new Date(a.date));

	sortedPosts = sortedPosts.map((post) => ({
		...post,
	}));

	return {
		posts: sortedPosts,
	};
};
