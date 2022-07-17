import {
  Button,
  ButtonGroup,
  Heading,
  HStack,
  IconButton,
  useColorMode,
} from "@chakra-ui/react";
import NavLink from "next/link";
import { GoLightBulb } from "react-icons/go";
import { FiSun,  } from "react-icons/fi";

const Navbar = () => {
  const { colorMode, toggleColorMode } = useColorMode();
  return (
    <HStack justifyContent="space-between" as="nav" w="full">
      <HStack alignItems="center">
        <NavLink href="/" passHref>
          <Heading p="2" as="a" size="lg" mr="2">
            Spotube
          </Heading>
        </NavLink>
        <ButtonGroup>
          <NavLink href="/other-downloads" passHref>
            <Button as="a" colorScheme="gray" variant="ghost">
              Other Downloads
            </Button>
          </NavLink>
          <NavLink href="/about" passHref>
            <Button as="a" variant="ghost" colorScheme="gray">
              About
            </Button>
          </NavLink>
        </ButtonGroup>
      </HStack>
      <IconButton
        variant="ghost"
        icon={colorMode == "light" ? <GoLightBulb /> : <FiSun />}
        aria-label="Dark Mode Toggle"
        onClick={() => {
          toggleColorMode();
        }}
      />
    </HStack>
  );
};

export default Navbar;
