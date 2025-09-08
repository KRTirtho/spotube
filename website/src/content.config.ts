import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const docs = defineCollection({
  schema: z.object({
    title: z.string().optional().default('(Title)'),
		description: z.string().optional().default('(Description)'),
		pubDate: z.date().optional(),
		tags: z.array(z.string()).optional(),
		order: z.number().optional().default(0)
  }),
  loader: glob({
    base: './src/content/docs',
		pattern: ['**/*.mdx', '!**/_*.mdx']
  }),
});

export const collections = { docs };