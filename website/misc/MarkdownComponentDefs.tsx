import { Link as Anchor, Heading, Text, chakra } from "@chakra-ui/react";

export const MarkdownComponentDefs = {
  a: (props: any) => <Anchor {...props} color="blue.500" />,
  h1: (props: any) => <Heading {...props} size="xl" mt="5" mb="1.5" />,
  h2: (props: any) => <Heading {...props} size="lg" mt="5" mb="1.5" />,
  h3: (props: any) => <Heading {...props} size="md" mt="5" mb="1.5" />,
  h4: (props: any) => <Heading {...props} size="sm" />,
  h5: (props: any) => <Heading {...props} size="xs" />,
  h6: (props: any) => <Heading {...props} size="xs" />,
  p: (props: any) => <Text {...props} />,
  li: (props: any) => <chakra.li {...props} ml="4" />,
};
