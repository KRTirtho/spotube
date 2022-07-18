import fs from "fs";
import path from "path";
import { GetStaticProps, NextPage } from "next";
import matter from "gray-matter";
import ArticleCard from "components/ArticleCard";
import { VStack } from "@chakra-ui/react";
import Head from "next/head";

export interface BlogMetadata {
  title: string;
  cover_image: string;
  author: string;
  date: string;
  author_avatar_url: string;
  tags: string[];
  summary: string;
}

export interface BlogPost {
  slug: string;
  metadata: BlogMetadata;
}

interface Props {
  posts: BlogPost[];
}

export const getStaticProps: GetStaticProps<Props> = async () => {
  const posts = fs.readdirSync("posts").map((file) => {
    return {
      slug: file.replace(".md", ""),
      metadata: matter(fs.readFileSync(path.join("posts", file)))
        .data as BlogMetadata,
    };
  });

  return {
    props: {
      posts: posts.sort(
        // @ts-ignore
        (a, b) => new Date(b.metadata.date) - new Date(a.metadata.date)
      ),
    },
  };
};

const Blog: NextPage<Props> = ({ posts }) => {
  return (
    <VStack mx="5" my="5" spacing="7">
      <Head>
        <title>Spotube - Blogs</title>
      </Head>
      {posts.map((post) => {
        return (
          <ArticleCard
            key={post.slug}
            metadata={post.metadata}
            slug={post.slug}
          />
        );
      })}
    </VStack>
  );
};

export default Blog;
