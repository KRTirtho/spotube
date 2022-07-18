import {
  Center,
  CircularProgress,
  Heading,
  HStack,
  VStack,
} from "@chakra-ui/react";
import UserDetailedCard from "components/UserDetailedCard";
import { octokit } from "configurations/ocotokit";
import useSwr from "swr";

const maintainers = ["KRTirtho", "RustyApple"];

const About = () => {
  const { data } = useSwr("contributors", () =>
    octokit.repos.listContributors({
      owner: "KRTirtho",
      repo: "spotube",
    })
  );

  return (
    <VStack my="20" mx="10">
      <Heading>Maintainers</Heading>

      <HStack pb="20" gap="40px" wrap="wrap" justify="center" align="start">
        {data ? (
          data.data.map((contributor) => {
            if (!maintainers.includes(contributor.login!)) return;
            return (
              <UserDetailedCard
                key={contributor.id}
                emoji="⚡"
                username={contributor.login!}
              />
            );
          })
        ) : (
          <Center>
            <CircularProgress />
          </Center>
        )}
      </HStack>

      <Heading>Valuable Code Contributors💝</Heading>
      <HStack gap="40px" wrap="wrap" justify="center" align="start">
        {data ? (
          data.data.map((contributor) => {
            if (maintainers.includes(contributor.login!)) return;
            return (
              <UserDetailedCard
                key={contributor.id}
                emoji="💪💝"
                username={contributor.login!}
              />
            );
          })
        ) : (
          <Center>
            <CircularProgress />
          </Center>
        )}
      </HStack>
    </VStack>
  );
};

export default About;
