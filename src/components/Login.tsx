import React, { useContext, useState } from "react";
import { LineEdit, Text, Button, View } from "@nodegui/react-nodegui";
import authContext from "../context/authContext";
import { CredentialKeys, Credentials } from "../app";

function Login() {
  const { setIsLoggedIn } = useContext(authContext);
  const [credentials, setCredentials] = useState({
    clientId: "",
    clientSecret: "",
  });

  const [touched, setTouched] = useState({
    clientId: false,
    clientSecret: false,
  });

  type fieldNames = "clientId" | "clientSecret";

  function textChanged(text: string, fieldName: fieldNames) {
    setCredentials({ ...credentials, [fieldName]: text });
  }

  function textEdited(name: fieldNames) {
    if (!touched[name]) {
      setTouched({ ...touched, [name]: true });
    }
  }

  return (
    <View style={`flex: 1; flex-direction: 'column';`}>
      <Text>{`<center><h1>Add Spotify & Youtube credentials to get started</h1></center>`}</Text>
      <Text>{`<center><p>Don't worry any of the credentials won't be collected or used for abuses</p></center>`}</Text>
      <LineEdit
        on={{
          textChanged: (t) => textChanged(t, "clientId"),
          textEdited() {
            textEdited("clientId");
          },
        }}
        text={credentials.clientId}
        placeholderText="spotify clientId"
      />
      <LineEdit
        on={{
          textChanged: (t) => textChanged(t, "clientSecret"),
          textEdited() {
            textEdited("clientSecret");
          },
        }}
        text={credentials.clientSecret}
        placeholderText="spotify clientSecret"
      />
      <Button
        on={{
          clicked: () => {
            localStorage.setItem(
              CredentialKeys.credentials,
              JSON.stringify({
                clientId: credentials.clientId,
                clientSecret: credentials.clientSecret,
              } as Credentials)
            );
            setIsLoggedIn(true);
          },
        }}
        text="Add"
      />
    </View>
  );
}

export default Login;
