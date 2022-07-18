import {
  Link as Anchor,
  Heading,
  Text,
  chakra,
  Code,
  HStack,
  Divider,
  Box,
} from "@chakra-ui/react";
import { Options } from "react-markdown";

export const MarkdownComponentDefs: Options["components"] = {
  a: (props: any) => <Anchor {...props} color="blue.500" />,
  h1: (props: any) => <Heading {...props} size="xl" mt="5" mb="1.5" />,
  h2: (props: any) => <Heading {...props} size="lg" mt="5" mb="1.5" />,
  h3: (props: any) => <Heading {...props} size="md" mt="5" mb="1.5" />,
  h4: (props: any) => <Heading {...props} size="sm" />,
  h5: (props: any) => <Heading {...props} size="xs" />,
  h6: (props: any) => <Heading {...props} size="xs" />,
  p: (props: any) => <Text {...props} />,
  li: (props: any) => <chakra.li {...props} ml="4" />,
  code: (props) => (
    <Code
      {...props}
      p={!props.inline ? 5 : 0}
      overflow="scroll"
      colorScheme="gray"
      maxW="full"
    />
  ),
  blockquote: (props) => {
    return (
      <HStack bgColor="blackAlpha.300" py="3" px="2">
        <Box borderLeft="2px solid gray" pl="2">
          <Text as="span" fontSize="sm">
            {props.children}
          </Text>
        </Box>
      </HStack>
    );
  },
};
