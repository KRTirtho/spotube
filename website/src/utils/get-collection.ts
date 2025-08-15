import type { HTMLAttributes } from "astro/types";
import { getCollection, type CollectionEntry } from "astro:content";

interface NavigationItem extends HTMLAttributes<"a"> {
  title: string;
  tag?: string;
}

export interface NavigationGroup {
  title: string;
  items: NavigationItem[];
}

function sortByOrder(a: CollectionEntry<"docs">, b: CollectionEntry<"docs">) {
  return a.data.order - b.data.order;
}

async function queryCollection(startsWith: string) {
  return (
    await getCollection("docs", (entry) => {
      if (!entry.id.startsWith(startsWith)) return false;
      if (entry.id.split("/").length > 2) return false;
      if (entry.id.endsWith("meta")) return false;
      return true;
    })
  ).toSorted(sortByOrder);
}
function toNavItems(entries: CollectionEntry<"docs">[]) {
  return entries.map((page) => ({
    title: page.data.title,
    href: `/docs/${page.id}`,
  }));
}

export async function getNavigationCollection() {
  // Define navigation sections
  const sections: [
    string,
    string,
    (prefix: string) => Promise<CollectionEntry<"docs">[]>
  ][] = [
    ["Get Started", "get-started/", queryCollection],
    ["Developing Plugins", "developing-plugins/", queryCollection],
    ["Plugin APIs", "plugin-apis/", queryCollection],
    ["Reference", "reference/", queryCollection],
  ];

  // Build navigation dynamically
  const navigation: NavigationGroup[] = await Promise.all(
    sections.map(async ([title, prefix, queryFn]) => ({
      title,
      items: toNavItems(await queryFn(prefix)),
    }))
  );

  return navigation;
}
