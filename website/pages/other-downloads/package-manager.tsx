import {
  Box,
  Code,
  Heading,
  HStack,
  Icon,
  Image,
  Link,
  Text,
  VStack,
} from "@chakra-ui/react";
import { CodeBlock } from "components/CodeBlock";
import { FcLinux } from "react-icons/fc";
import { BsWindows } from "react-icons/bs";
// import { DisplayAd } from "components/special";

export default function PackageManagerPage() {
  return (
    <VStack p="5" spacing="5">
      <VStack align="start" w="full" maxW="2xl">
        <Heading>Installation using Package Managers</Heading>
        <Text>
          If you don&apos;t want to download the binary of Spotube, you can use
          various package managers to install Spotube too (only Windows & Linux
          now)
        </Text>
        <Heading size="lg" pt="5">
          Linux
          <Icon>
            <FcLinux />
          </Icon>
        </Heading>
        <Heading size="md" pt="3">
          Flatpak
        </Heading>
        <Text>
          Make sure Flatpak is installed in your Linux device & Run the
          following command in the terminal:
        </Text>
        <CodeBlock>$ flatpak install com.github.KRTirtho.Spotube</CodeBlock>
        <Heading size="md" pt="3">
          AUR
        </Heading>
        <Text>
          If you&apos;re an Arch Linux user, you can also install Spotube from
          AUR. Make sure you have <Code>yay</Code> or <Code>pamac</Code> or{" "}
          <Code>paru</Code> installed in your system. And Run the Following
          command in the Terminal:
        </Text>
        <CodeBlock>
          # for pamac user
          <br />$ pamac install spotube-bin
        </CodeBlock>
        <CodeBlock>
          # for paru user
          <br />$ paru -Sy spotube-bin
        </CodeBlock>
        <CodeBlock>
          # for yay user
          <br />$ yay -Sy spotube-bin
        </CodeBlock>
        <Box w="full">
          {/* <DisplayAd slot="9501208974" /> */}
        </Box>
        <HStack align="center" pt="5">
          <Heading size="lg">Windows</Heading>
          <BsWindows fontSize="25px" color="#00A4EF" />
        </HStack>
        <Heading size="md" pt="3">
          Chocolatey
        </Heading>
        <Text>
          Spotube is available in{" "}
          <Link
            color="blue.500"
            target="_blank"
            href="community.chocolatey.org"
          >
            community.chocolatey.org
          </Link>{" "}
          repo. If you have chocolatey install in your system just run following
          command in an Elevated Command Prompt or PowerShell:
        </Text>
        <CodeBlock>$ choco install spotube</CodeBlock>
        <Heading size="md" pt="3">
          WinGet
        </Heading>
        <Text>
          Yes, Spotube is also available in the Official Windows PackageManager
          WinGet. Make sure you have WinGet installed in your Windows machine
          and run following in a Terminal:
        </Text>
        <CodeBlock>$ winget install --id KRTirtho.Spotube</CodeBlock>
        <Box w="full">
          {/* <DisplayAd slot="9501208974" /> */}
        </Box>
        <Heading pt="5">Install from App Stores</Heading>
        <Heading size="md">Android (F-Droid)</Heading>
        <Text>
          Spotube for Android is available in the F-Droid repositories too. So
          you can install it directly from F-Droid Android application too
        </Text>
        <Link
          href="https://f-droid.org/packages/oss.krtirtho.spotube/"
          target="_blank"
        >
          <Image
            src="https://user-images.githubusercontent.com/61944859/174589876-bace24c0-b3fd-4c4a-bdb4-6fa82b5853ec.png"
            alt="F-Droid Download"
            height="70"
            width="240"
          />
        </Link>
      </VStack>
    </VStack>
  );
}
