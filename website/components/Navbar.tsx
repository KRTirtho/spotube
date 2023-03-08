import {
  Box,
  Button,
  chakra,
  CloseButton,
  Flex,
  Heading,
  HStack,
  IconButton,
  Link,
  useColorMode,
  useColorModeValue,
  useDisclosure,
  VisuallyHidden,
  VStack,
} from "@chakra-ui/react";
import NavLink from "next/link";
import { GoLightBulb } from "react-icons/go";
import { FiGithub, FiSun } from "react-icons/fi";
import Image from "next/image";
import React from "react";
import { AiOutlineMenu } from "react-icons/ai";
import { BsHeartFill } from "react-icons/bs";

const Navbar = () => {
  const bg = useColorModeValue("white", "gray.800");
  const mobileNav = useDisclosure();
  const { colorMode, toggleColorMode } = useColorMode();
  return (
    <React.Fragment>
      <chakra.header
        bg={bg}
        w="full"
        px={{
          base: 1,
          sm: 3,
        }}
        py={2}
        shadow="md"
        _dark={{
          bgColor: "#212121",
        }}
      >
        <Flex alignItems="center" justifyContent="space-between">
          <Flex align="center">
            <NavLink href="/">
              <Image
                src="/spotube-logo.svg"
                alt="Logo"
                height="60"
                width="60"
                layout="fixed"
              />
            </NavLink>
            <VisuallyHidden>Spotube</VisuallyHidden>
            <NavLink href="/" passHref>
              <Heading p="2" as="a" size="lg" mr="2">
                Spotube
              </Heading>
            </NavLink>
          </Flex>
          <HStack display="flex" alignItems="center" spacing={1}>
            <HStack
              spacing={1}
              mr={1}
              color="brand.500"
              display={{
                base: "none",
                md: "inline-flex",
              }}
            >
              <NavLink href="/other-downloads" passHref>
                <Button as="a" colorScheme="gray" variant="ghost">
                  Downloads
                </Button>
              </NavLink>
              <NavLink href="/blog" passHref>
                <Button as="a" variant="ghost" colorScheme="gray">
                  Blog
                </Button>
              </NavLink>
              <NavLink href="/about" passHref>
                <Button as="a" variant="ghost" colorScheme="gray">
                  About
                </Button>
              </NavLink>
              <Button
                as={Link}
                href="https://github.com/KRTirtho/spotube"
                bgColor="black"
                color="white"
                target="_blank"
                _hover={{
                  textDecor: "none",
                  bgColor: "blackAlpha.800",
                }}
                _active={{
                  bgColor: "blackAlpha.700",
                }}
                rightIcon={<FiGithub />}
              >
                Give us a ⭐ on
              </Button>
            </HStack>
            <Button
              size={{
                base: "sm",
                md: "sm",
                lg: "md",
              }}
              as={Link}
              href="https://opencollective.com/spotube"
              bgColor="pink.100"
              color="pink.500"
              _hover={{
                bgColor: "pink.200",
                textDecor: "none",
              }}
              _active={{
                bgColor: "pink.100",
              }}
              rightIcon={<BsHeartFill />}
              target="_blank"
            >
              Donate us
            </Button>
            <IconButton
              variant="ghost"
              icon={colorMode == "light" ? <GoLightBulb /> : <FiSun />}
              aria-label="Dark Mode Toggle"
              onClick={() => {
                toggleColorMode();
              }}
            />
            <Box
              display={{
                base: "inline-flex",
                md: "none",
              }}
            >
              <IconButton
                display={{
                  base: "flex",
                  md: "none",
                }}
                aria-label="Open menu"
                fontSize="20px"
                color="gray.800"
                _dark={{
                  color: "inherit",
                }}
                variant="ghost"
                icon={<AiOutlineMenu />}
                onClick={mobileNav.onOpen}
              />

              <VStack
                pos="absolute"
                top={0}
                left={0}
                right={0}
                display={mobileNav.isOpen ? "flex" : "none"}
                flexDirection="column"
                p={2}
                pb={4}
                m={2}
                bg={bg}
                spacing={3}
                rounded="sm"
                shadow="sm"
              >
                <CloseButton
                  aria-label="Close menu"
                  onClick={mobileNav.onClose}
                />
                <NavLink href="/other-downloads" passHref>
                  <Button w="full" as="a" colorScheme="gray" variant="ghost">
                    Downloads
                  </Button>
                </NavLink>
                <NavLink href="/blog" passHref>
                  <Button w="full" as="a" variant="ghost" colorScheme="gray">
                    Blog
                  </Button>
                </NavLink>
                <NavLink href="/about" passHref>
                  <Button w="full" as="a" variant="ghost" colorScheme="gray">
                    About
                  </Button>
                </NavLink>
                <Button
                  as={Link}
                  href="https://github.com/KRTirtho/spotube"
                  bgColor="black"
                  color="white"
                  target="_blank"
                  w="full"
                  _hover={{
                    textDecor: "none",
                    bgColor: "blackAlpha.800",
                  }}
                  _active={{
                    bgColor: "blackAlpha.700",
                  }}
                  rightIcon={<FiGithub />}
                >
                  Give us a ⭐ on
                </Button>
              </VStack>
            </Box>
          </HStack>
        </Flex>
      </chakra.header>
    </React.Fragment>
  );
};

export default Navbar;
