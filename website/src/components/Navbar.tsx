import {
  Button,
  ButtonGroup,
  Heading,
  HStack,
  IconButton,
  useColorMode,
} from "@hope-ui/solid";
import { NavLink } from "solid-app-router";
import { FaLightbulb } from "solid-icons/fa";
import { FiSun } from "solid-icons/fi";

const Navbar = () => {
  const { colorMode, toggleColorMode } = useColorMode();
  return (
    <HStack py="$2" justifyContent="space-between" as="nav" w="$full">
      <section>
        <Heading p="$2" size="3xl" mr="$2" as={NavLink} href="/">
          Spotube
        </Heading>
        <ButtonGroup>
          <Button
            variant="ghost"
            size="sm"
            as={NavLink}
            href="/other-downloads"
          >
            Other Downloads
          </Button>
          <Button variant="ghost" size="sm" as={NavLink} href="/about">
            About
          </Button>
        </ButtonGroup>
      </section>
      <IconButton
        variant="ghost"
        icon={colorMode() == "dark" ? <FaLightbulb /> : <FiSun />}
        aria-label="Dark Mode Toggle"
        onClick={() => {
          toggleColorMode();
        }}
      />
    </HStack>
  );
};

export default Navbar;
