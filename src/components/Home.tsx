import React from "react";
import { Button, ScrollArea, View } from "@nodegui/react-nodegui";
import { QueryCacheKeys } from "../conf";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import PlaceholderApplet from "./shared/PlaceholderApplet";
import useSpotifyInfiniteQuery from "../hooks/useSpotifyInfiniteQuery";
import CategoryCardView from "./shared/CategoryCardView";

function Home() {
  const { data: pagedCategories, isError, refetch, isLoading, hasNextPage, isFetchingNextPage, fetchNextPage } = useSpotifyInfiniteQuery<SpotifyApi.PagingObject<SpotifyApi.CategoryObject>>(
    QueryCacheKeys.categories,
    (spotifyApi, { pageParam }) => spotifyApi.getCategories({ country: "US", limit: 10, offset: pageParam }).then((categoriesReceived) => categoriesReceived.body.categories),
    {
      getNextPageParam(lastPage) {
        if (lastPage.next) {
          return lastPage.offset + lastPage.limit;
        }
      },
    }
  );

  const categories = pagedCategories?.pages
    .map((page) => page.items)
    .filter(Boolean)
    .flat(1);
  categories?.unshift({ href: "", icons: [], id: "featured", name: "Featured" });
  return (
    <ScrollArea style={`flex-grow: 1; border: none;`}>
      <View style={`flex-direction: 'column'; align-items: 'center'; flex: 1;`}>
        <PlaceholderApplet error={isError} message="Failed to query genres" reload={refetch} helps loading={isLoading} />
        {categories?.map((category, index) => {
          return <CategoryCard key={index + category.id} id={category.id} name={category.name} />;
        })}
        {hasNextPage && <Button on={{ clicked: () => fetchNextPage() }} text="Load More" enabled={!isFetchingNextPage} />}
      </View>
    </ScrollArea>
  );
}

export default Home;

interface CategoryCardProps {
  id: string;
  name: string;
}

const CategoryCard = ({ id, name }: CategoryCardProps) => {
  const { data: playlists, isError } = useSpotifyQuery<SpotifyApi.PlaylistObjectSimplified[]>(
    [QueryCacheKeys.categoryPlaylists, id],
    async (spotifyApi) => {
      const option = { limit: 4 };
      let res;
      if (id === "featured") {
        res = await spotifyApi.getFeaturedPlaylists(option);
      } else {
        res = await spotifyApi.getPlaylistsForCategory(id, option);
      }
      return res.body.playlists.items;
    },
    { initialData: [] }
  );

  return <CategoryCardView url={`/genre/playlists/${id}`} isError={isError} name={name} playlists={playlists ?? []} />;
};
