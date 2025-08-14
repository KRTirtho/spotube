// @ts-check
import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";
import react from "@astrojs/react";
import mdx from "@astrojs/mdx";
import rehypeSlug from "rehype-slug";
import rehypeAutolinkHeadings from "rehype-autolink-headings";
import pagefind from "astro-pagefind";

// https://astro.build/config
export default defineConfig({
  vite: {
    plugins: [tailwindcss()],
  },
  markdown: {
    syntaxHighlight: "shiki",
    shikiConfig: {
      langAlias: {
        hetu_script: "javascript",
      },
    },
    gfm: true,
    rehypePlugins: [
      [rehypeSlug, {}],
      [
        rehypeAutolinkHeadings,
        {
          behavior: "wrap", // Adds the link at the end of the heading
          properties: {
            className: ["heading-link"], // Add a class for styling
            "aria-hidden": "true",
          },
          content: {
            // Optional: Use an SVG icon or text for the link
            type: "element",
            tagName: "span",
            properties: { className: ["icon", "icon-link"] },
            children: [{ type: "text", value: " #" }],
          },
        },
      ],
    ],
  },
  integrations: [react(), mdx(), pagefind()],
  redirects: {
    "/docs": "/docs/get-started/introduction",
    "/docs/get-started": "/docs/get-started/introduction",
    "/docs/developing-plugins": "/docs/developing-plugins/introduction",
    "/docs/plugin-apis": "/docs/plugin-apis/webview",
    "/docs/reference": "/docs/reference/models",
  },
});
