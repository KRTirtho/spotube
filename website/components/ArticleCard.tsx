import { Link, Flex, Box, chakra, Image, Button, Text } from "@chakra-ui/react";
import { BlogPost } from "pages/blog";
import { FC } from "react";
import NavLink from "next/link";

const ArticleCard: FC<BlogPost> = ({
  metadata: {
    author,
    author_avatar_url,
    cover_image,
    tags,
    title,
    summary,
    date,
  },
  slug,
}) => {
  return (
    <Box
      mx="auto"
      rounded="lg"
      shadow="md"
      bg="white"
      _dark={{
        bg: "#212121",
      }}
      maxW="2xl"
    >
      <Image
        roundedTop="lg"
        w="full"
        h={64}
        fit="cover"
        src={cover_image}
        alt="Article"
      />

      <Box p={6}>
        <Box>
          {tags.map((tag, i) => {
            return (
              <chakra.span
                key={i}
                px={3}
                py={1}
                mx="1"
                bg="gray.600"
                color="gray.100"
                fontSize="sm"
                fontWeight="700"
                rounded="md"
              >
                {tag}
              </chakra.span>
            );
          })}
          <NavLink href={`/blog/${slug}`} passHref>
            <Link
              display="block"
              color="gray.800"
              _dark={{
                color: "white",
              }}
              fontWeight="bold"
              fontSize="2xl"
              mt={2}
              _hover={{
                color: "gray.600",
                textDecor: "underline",
              }}
            >
              {title}
            </Link>
          </NavLink>
          <chakra.p
            mt={2}
            fontSize="sm"
            color="gray.600"
            _dark={{
              color: "gray.400",
            }}
          >
            {summary}
          </chakra.p>
        </Box>

        <Box mt={4}>
          <Flex
            alignItems="center"
            justify="space-between"
            flexDirection={{ base: "column", md: "row" }}
          >
            <Flex alignItems="center">
              <Image
                h={10}
                fit="cover"
                rounded="full"
                src={author_avatar_url}
                alt="Avatar"
              />
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
            </Flex>
            <NavLink href={`/blog/${slug}`} passHref>
              <Button
                _hover={{ textDecor: "none" }}
                colorScheme="purple"
                as={Link}
              >
                Read the Full Article
              </Button>
            </NavLink>
          </Flex>
        </Box>
      </Box>
    </Box>
  );
};

export default ArticleCard;
