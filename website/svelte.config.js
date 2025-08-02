import adapter from '@sveltejs/adapter-cloudflare';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import { mdsvex } from 'mdsvex';
import readingTime from 'remark-reading-time';
import remarkExternalLinks from 'remark-external-links';
import slugPlugin from 'rehype-slug';
import autolinkHeadings from 'rehype-autolink-headings';
import relativeImages from 'mdsvex-relative-images';
import remarkGfm from 'remark-gfm';
import rehypeAutoAds from 'rehype-auto-ads';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	extensions: ['.svelte', '.svx', '.md'],
	// Consult https://kit.svelte.dev/docs/integrations#preprocessors
	// for more information about preprocessors
	preprocess: [
		vitePreprocess(),
		mdsvex({
			extensions: ['.svx', '.md'],
			highlight: {},
			layout: './src/lib/components/markdown/layout.svelte',
			smartypants: {
				dashes: 'oldschool'
			},

			remarkPlugins: [
				remarkGfm,
				// adds a `readingTime` frontmatter attribute
				readingTime(),
				relativeImages,
				// external links open in a new tab
				[remarkExternalLinks, { target: '_blank', rel: 'noopener' }]
			],
			rehypePlugins: [
				slugPlugin,
				[
					autolinkHeadings,
					{
						behavior: 'wrap'
					}
				],
				[
					rehypeAutoAds,
					{
						adCode: `
              <br/>
              <ins class="adsbygoogle"
                style="display:block; text-align:center;"
                data-ad-layout="in-article"
                data-ad-format="fluid"
                data-ad-client="ca-pub-6419300932495863"
                data-ad-slot="6788673194"
              ></ins>
              <br/>
              <script>
                (adsbygoogle = window.adsbygoogle || []).push({});
              </script>
            `,
            paragraphInterval: 2,
            maxAds: 5,
					}
				]
			]
		})
	],
	vitePlugin: {
		inspector: true
	},
	kit: {
		// adapter-auto only supports some environments, see https://kit.svelte.dev/docs/adapter-auto for a list.
		// If your environment is not supported or you settled on a specific environment, switch out the adapter.
		// See https://kit.svelte.dev/docs/adapters for more information about adapters.
		adapter: adapter()
	}
};
export default config;
