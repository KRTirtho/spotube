import { QMouseEvent, CursorShape } from "@nodegui/nodegui";
import { View, Button } from "@nodegui/react-nodegui";
import React, { FC } from "react";
import { useHistory } from "react-router";
import PlaylistCard from "./PlaylistCard";

interface CategoryCardProps {
  url: string;
  name: string;
  isError: boolean;
  playlists: SpotifyApi.PlaylistObjectSimplified[];
}

const categoryStylesheet = `
     #container{
       flex: 1;
       flex-direction: 'column';
       justify-content: 'center';
     }
     #anchor-heading{
       background: transparent;
       padding: 10px;
       border: none;
       outline: none;
       font-size: 20px;
       font-weight: bold;
       align-self: flex-start;
     }
     #child-view{
        flex: 1;
      }
     #anchor-heading:hover{
       border: none;
       outline: none;
       text-decoration: underline;
     }
  `;
const CategoryCard: FC<CategoryCardProps> = ({ name, isError, playlists, url }) => {
  const history = useHistory();
  function goToGenre(native: any) {
    const mouse = new QMouseEvent(native);
    if (mouse.button() === 1) {
      history.push(url, { name });
    }
  }
  if (isError) {
    return <></>;
  }
  return (
    <View id="container" styleSheet={categoryStylesheet}>
      <Button id="anchor-heading" cursor={CursorShape.PointingHandCursor} on={{ MouseButtonRelease: goToGenre }} text={name} />
      <View id="child-view">
        {playlists.map((playlist, index) => {
          return <PlaylistCard key={index + playlist.id} playlist={playlist} />;
        })}
      </View>
    </View>
  );
};

export default CategoryCard;
