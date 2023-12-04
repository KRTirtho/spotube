import { Flex, chakra, Link, IconButton } from "@chakra-ui/react";

import { FaGithub, FaRedditAlien } from "react-icons/fa";
import { FiTwitter } from "react-icons/fi";

const Footer = () => {
  return (
    <Flex
      w="full"
      as="footer"
      flexDir={{
        base: "column",
        sm: "row",
      }}
      align="center"
      justify="space-between"
      px="6"
      py="4"
      bg="white"
      _dark={{
        bg: "#282828",
      }}
    >
      <chakra.a
        href="#"
        fontSize="xl"
        fontWeight="bold"
        color="gray.600"
        _dark={{
          color: "white",
          _hover: {
            color: "gray.300",
          },
        }}
        _hover={{
          color: "gray.700",
        }}
      >
        Spotube
      </chakra.a>

      <chakra.p
        py={{
          base: "2",
          sm: "0",
        }}
        color="gray.800"
        _dark={{
          color: "white",
        }}
      >
        © {new Date().getFullYear()}, Spotube. All rights reserved
      </chakra.p>

      <Flex mx="-2">
        <IconButton
          colorScheme="gray"
          as={Link}
          aria-label="Github Link"
          href="https://github.com/KRTirtho/spotube"
          target="_blank"
          icon={<FaGithub />}
          variant="link"
        />
        <IconButton
          colorScheme="gray"
          as={Link}
          aria-label="Twitter Link"
          href="https://twitter.com/@KrTirtho"
          target="_blank"
          icon={<FiTwitter />}
          variant="link"
        />
        <IconButton
          colorScheme="gray"
          as={Link}
          aria-label="Reddit Link"
          href="https://reddit.com/r/FlutterDev/search/?q=spotube&restrict_sr=1&sr_nsfw="
          target="_blank"
          icon={<FaRedditAlien />}
          variant="link"
        />
      </Flex>
    </Flex>
  );
};

export default Footer;
