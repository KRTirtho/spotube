import fs from "fs";
import path from "path";
import { GetStaticPaths, GetStaticProps, NextPage } from "next";
import ReactMarkdown from "react-markdown";
import matter from "gray-matter";
import { BlogMetadata } from ".";
import gfm from "remark-gfm";
import gemoji from "remark-gemoji";
import { MarkdownComponentDefs } from "misc/MarkdownComponentDefs";
import {
  Box,
  chakra,
  Flex,
  Heading,
  Image,
  Text,
  VStack,
} from "@chakra-ui/react";
import Head from "next/head";

interface Props {
  metadata: BlogMetadata;
  content: string;
}

const BlogPost: NextPage<Props> = ({
  content,
  metadata: { author, author_avatar_url, cover_image, date, tags, title },
}) => {
  return (
    <VStack>
      <Head>
        <title>{title}</title>
      </Head>
      <Box w="full" maxH="xl" overflow="hidden" mb="5">
        <Image fit="cover" src={cover_image} alt={title} />
      </Box>
      <VStack
      align="start"
      spacing="4"
        maxW={{
          base: "full",
          lg: "70%",
          xl: "60%",
        }}
        py="5"
        px="10"
        w="full"
      >
        <Flex alignItems="center">
          <Image
            h="12"
            fit="cover"
            rounded="full"
            src={author_avatar_url}
            alt="Avatar"
          />
          <VStack spacing="0">
            <Text
              mx={2}
              fontWeight="bold"
              color="gray.700"
              _dark={{
                color: "gray.200",
              }}
            >
              {author}
            </Text>
            <chakra.span
              mx={1}
              fontSize="sm"
              color="gray.600"
              _dark={{
                color: "gray.300",
              }}
            >
              {date}
            </chakra.span>
          </VStack>
        </Flex>
        <Heading>{title}</Heading>
        <ReactMarkdown
          components={MarkdownComponentDefs}
          remarkPlugins={[gfm, gemoji]}
        >
          {content}
        </ReactMarkdown>
      </VStack>
    </VStack>
  );
};

export default BlogPost;

export const getStaticPaths: GetStaticPaths = async () => {
  const paths = fs.readdirSync("posts").map((file) => {
    return {
      params: {
        slug: file.replace(".md", ""),
      },
    };
  });
  return {
    paths,
    fallback: false,
  };
};

export const getStaticProps: GetStaticProps<Props> = async (ctx) => {
  const { content, data } = matter(
    fs.readFileSync(path.join("posts", `${ctx.params?.slug}.md`), "utf-8")
  );
  return {
    props: {
      content,
      metadata: data as BlogMetadata,
    },
  };
};
