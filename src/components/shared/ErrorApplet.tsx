import { View, Button, Text } from "@nodegui/react-nodegui";
import React from "react"

interface ErrorAppletProps {
	message?: string;
	reload: Function;
	helps?: boolean;
}

function ErrorApplet({ message, reload, helps }: ErrorAppletProps) {
	return (
		<View style="flex-direction: 'column'; align-items: 'center';">
			<Text openExternalLinks>{`
      	<h3>${message ? message : 'An error occured'}</h3>
      	${helps ? `<p>Check if you're connected to internet & then try again. If the issue still persists ask for help or create a <a href="https://github.com/krtirtho/spotube/issues">issue</a>
      	  </p>`: ``
				}
      `}</Text>
			<Button on={{ clicked() { reload() } }} text="Reload" />
		</View>
	)
}

export default ErrorApplet;