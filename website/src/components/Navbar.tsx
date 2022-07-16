import { Button, ButtonGroup, Heading, HStack } from "@hope-ui/solid";
import { NavLink } from "solid-app-router";

const Navbar = () => {
  return (
    <HStack as="nav" w="$full">
      <Heading p="$2" size="3xl" mr="$2" as={NavLink} href="/">
        Spotube
      </Heading>
      <ButtonGroup>
        <Button variant="ghost" size="sm" as={NavLink} href="/all-versions">
          All Versions
        </Button>
        <Button variant="ghost" size="sm" as={NavLink} href="/all-versions">
          About
        </Button>
      </ButtonGroup>
    </HStack>
  );
};

export default Navbar;
