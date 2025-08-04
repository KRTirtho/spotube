import type { RestEndpointMethodTypes } from "@octokit/rest";
import { LuBook, LuChevronDown, LuChevronUp } from "react-icons/lu";
import markdownIt from "markdown-it";
import sanitizeHtml from "sanitize-html";

interface Props {
  release: RestEndpointMethodTypes["repos"]["getReleaseByTag"]["response"]["data"];
}

export default function ReleaseBody({ release }: Props) {
  const summary = "Release Notes & Changelogs";
  const body = release.body ?? "No release notes available.";

  const md = markdownIt({
    html: true,
    linkify: true,
    typographer: true,
  });

  const sanitizedBody = sanitizeHtml(md.render(body));
  return (<details className="rounded-md p-4 my-4 preset-tonal-primary group">
    <summary className="flex items-center cursor-pointer font-semibold text-lg gap-2">
      <LuBook className="inline" />
      {summary}
      <span className="ml-auto flex items-center">
        <span className="block group-open:hidden">
          <LuChevronDown />
        </span>
        <span className="hidden group-open:block">
          <LuChevronUp />
        </span>
      </span>
    </summary>
    <article
      className="prose lg:prose-xl dark:prose-invert"
      dangerouslySetInnerHTML={{ __html: sanitizedBody }}
    />
  </details>)
}