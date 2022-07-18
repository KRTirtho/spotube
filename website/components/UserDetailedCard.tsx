import {
  Flex,
  Box,
  Icon,
  chakra,
  Image,
  HStack,
  IconButton,
  Link,
  CircularProgress,
} from "@chakra-ui/react";
import { MdEmail, MdLocationOn } from "react-icons/md";
import { BsFillBriefcaseFill } from "react-icons/bs";
import { FC } from "react";
import { FaGithub } from "react-icons/fa";
import { FiTwitter } from "react-icons/fi";
import { octokit } from "configurations/ocotokit";
import useSWR from "swr";

interface UserDetailedCardProps {
  username: string;
  emoji: string;
}

const UserDetailedCard: FC<UserDetailedCardProps> = ({ username, emoji }) => {
  const { data } = useSWR(`user-${username}}`, () =>
    octokit.users.getByUsername({ username })
  );

  if (!data) {
    return <CircularProgress />;
  }

  return (
    <Box
      w="xs"
      bg="white"
      _dark={{
        bg: "#212121",
      }}
      shadow="xl"
      rounded="lg"
      overflow="hidden"
    >
      <Image
        w="full"
        h={56}
        fit="cover"
        objectPosition="center"
        src={data.data.avatar_url}
        alt="avatar"
      />

      <Flex
        alignItems="center"
        px={6}
        py={3}
        bg="#1c1c1c"
        _light={{ bg: "gray.50" }}
      >
        <span>{emoji}</span>
        <chakra.h1 mx={3} fontWeight="bold" fontSize="lg">
          {data.data.name ?? data.data.login}
        </chakra.h1>
      </Flex>

      <Box py={4} px={6}>
        <chakra.p
          py={2}
          color="gray.700"
          _dark={{
            color: "gray.400",
          }}
        >
          {data.data.bio}
        </chakra.p>

        {data.data.company && (
          <Flex
            alignItems="center"
            mt={4}
            color="gray.700"
            _dark={{
              color: "gray.200",
            }}
          >
            <Icon as={BsFillBriefcaseFill} h={6} w={6} mr={2} />

            <chakra.h1 px={2} fontSize="sm">
              {data.data.company}
            </chakra.h1>
          </Flex>
        )}

        {data.data.location && (
          <Flex
            alignItems="center"
            mt={4}
            color="gray.700"
            _dark={{
              color: "gray.200",
            }}
          >
            <Icon as={MdLocationOn} h={6} w={6} mr={2} />

            <chakra.h1 px={2} fontSize="sm">
              {data.data.location}
            </chakra.h1>
          </Flex>
        )}
        {data.data.email && (
          <Flex
            alignItems="center"
            mt={4}
            color="gray.700"
            _dark={{
              color: "gray.200",
            }}
          >
            <Icon as={MdEmail} h={6} w={6} mr={2} />
            <chakra.h1 px={2} fontSize="sm">
              {data.data.email}
            </chakra.h1>
          </Flex>
        )}
        <HStack justify="center" pt="4">
          <IconButton
            colorScheme="gray"
            as={Link}
            aria-label="Github Link"
            href={data.data.html_url}
            target="_blank"
            icon={<FaGithub />}
            variant="link"
          />
          {data.data.twitter_username && (
            <IconButton
              colorScheme="gray"
              as={Link}
              aria-label="Twitter Link"
              href={`https://twitter.com/${data.data.twitter_username}`}
              target="_blank"
              icon={<FiTwitter />}
              variant="link"
            />
          )}
        </HStack>
      </Box>
    </Box>
  );
};

export default UserDetailedCard;
