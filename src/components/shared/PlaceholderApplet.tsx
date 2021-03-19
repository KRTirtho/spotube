import { View, Button, Text } from "@nodegui/react-nodegui";
import { QLabel, QMovie, } from "@nodegui/nodegui";
import React, { useEffect, useRef } from "react";
import { loadingSpinner } from "../../icons";

interface ErrorAppletProps {
  error: boolean;
  loading: boolean;
  message?: string;
  reload: Function;
  helps?: boolean;
}

function PlaceholderApplet({ message, reload, helps, loading, error }: ErrorAppletProps) {
  const textRef = useRef<QLabel>();
  const movie = new QMovie();

  useEffect(() => {
    movie.setFileName(loadingSpinner);
    textRef.current?.setMovie(movie);
    textRef.current?.show();
    movie.start();
  }, []);
  if (loading) {
    return (
      <View style="flex: 1; justify-content: 'center'; align-items: 'center';">
        <Text ref={textRef} />
      </View>
    );
  } else if (error) {
    return (
      <View style="flex-direction: 'column'; align-items: 'center';">
        <Text openExternalLinks>{`
      	<h3>${message ? message : "An error occured"}</h3>
      	${
          helps
            ? `<p>Check if you're connected to internet & then try again. If the issue still persists ask for help or create a <a href="https://github.com/krtirtho/spotube/issues">issue</a>
      	  </p>`
            : ``
        }
      `}</Text>
        <Button
          on={{
            clicked() {
              reload();
            },
          }}
          text="Reload"
        />
      </View>
    );
  }
  return <></>;
}

export default PlaceholderApplet;
