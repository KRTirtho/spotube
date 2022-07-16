import { Anchor, Heading, Text, hope } from "@hope-ui/solid";

export const MarkdownComponentDefs = {
  a: (props: any) => <Anchor {...props} color="$info10" />,
  h1: (props: any) => <Heading {...props} size="4xl" mt="$5" mb="$1_5" />,
  h2: (props: any) => <Heading {...props} size="3xl" mt="$5" mb="$1_5" />,
  h3: (props: any) => <Heading {...props} size="2xl" mt="$5" mb="$1_5" />,
  h4: (props: any) => <Heading {...props} size="md" />,
  h5: (props: any) => <Heading {...props} size="lg" />,
  h6: (props: any) => <Heading {...props} size="md" />,
  p: (props: any) => <Text {...props} />,
  li: (props: any) => <hope.li {...props} ml="$4" />,
};
