import { chakra } from "@chakra-ui/react";
import { FC, ReactNode } from "react";

type Props = {
  children: ReactNode;
};

export const CodeBlock: FC<Props> = ({ children }) => {
  return (
    <chakra.pre
      bgColor="gray.200"
      p="3"
      borderRadius="md"
      _dark={{
        bgColor: "gray.700",
      }}
      w="lg"
    >
      <chakra.code>{children}</chakra.code>
    </chakra.pre>
  );
};
