# Troubleshooting Compose in REPL

Common issues when rendering Compose components in the REPL and how to resolve them.

## Kotlin Multiplatform (KMP) Issues

The Gradle REPL only supports JVM-based source sets.

- **Issue**: Attempting to start the REPL on a common, iOS, or Android source set fails.
- **Solution**: Select a JVM or Desktop target source set. Recommended names: `jvmMain`, `jvmTest`, `desktopMain`, `desktopTest`.
- **Issue**: Dependencies from `commonMain` are not resolving.
- **Solution**: Starting the REPL on a JVM-specific source set that *depends* on `commonMain` (which is standard KMP structure) will include all inherited dependencies. Ensure the project is built before starting.

## Android Limitation (FUNDAMENTAL)

**IMPORTANT: `runComposeUiTest` and `captureToImage()` CANNOT work on Android.**

This is not a bug or limitation that can be fixed—it is a fundamental architectural incompatibility:

- `runComposeUiTest` requires desktop Compose runtime with Skiko rendering
- Android's ART does not support desktop Compose testing APIs
- `captureToImage()` relies on desktop-specific rendering pipelines

**Solution**: Put your Composables in `commonMain` and run the REPL on a JVM target (`jvmMain`, `jvmTest`, `desktopMain`, or `desktopTest`).

## `ClassNotFoundException: androidx.compose.ui.test.junit4.DesktopComposeTestRule`

This occurs when the Compose UI Test dependencies are not on the REPL's classpath.
The REPL uses the runtime classpath of the selected `sourceSet`.
If you are using `sourceSet: "main"`, but the test dependencies are in `testImplementation`, they won't be included.

**Solutions:**

1. **(Preferred)** Start the REPL with `sourceSet: "test"`. This usually includes the required test dependencies.
2. Add the dependency manually using `additionalDependencies` if using `sourceSet: "main"`:
   ```json
   {
     "command": "start",
     "projectPath": ":my-app",
     "sourceSet": "main",
     "additionalDependencies": ["org.jetbrains.compose.ui:ui-test-junit4-desktop:1.7.0"]
   }
   ```

## `java.lang.NoClassDefFoundError: org/jetbrains/skiko/SkiaLayer`

Skiko is the rendering engine for Compose Desktop. It might be missing if the project is not correctly configured for Compose Desktop or if dependencies are incomplete.

**Solution:**
Ensure `compose.desktop.currentOs` is in the project's dependencies or add it to `additionalDependencies`.

## Composable Renders but No Image is Shown

The `project_repl` tool only returns content that is explicitly rendered via `responder.render(value)` or the result of the last expression in the script.

**Solution:**
Ensure you call `responder.render(bitmap)` inside your `runComposeUiTest` block.

```kotlin
runComposeUiTest {
    setContent { MyComposable() }
    responder.render(onRoot().captureToImage()) // <--- Important!
}
```

## `Unresolved reference: runComposeUiTest`

The `runComposeUiTest` function may be located in different packages depending on your version of Compose or whether you are using JetBrains Compose.

**Solutions:**

1. Check the correct import for your project. Common ones:
    - `androidx.compose.ui.test.runComposeUiTest`
    - `org.jetbrains.compose.ui.test.runComposeUiTest` (for older or specific JetBrains Compose versions)
2. Ensure you are using a compatible version of the `ui-test` library. Some older versions used `runDesktopComposeUiTest` or similar.

## `Unresolved reference: responder`

The `responder` property is automatically injected into the REPL session by the worker.
If it is unresolved, check if you have a custom `providedProperties` in your script configuration (usually not an issue for users).
Ensure you are using the `project_repl` tool which uses the custom REPL worker.

## `java.lang.IllegalStateException: runComposeUiTest { ... } needs to be called from the main thread`

On some platforms, Compose UI tests might require being run on the main/UI thread.
The REPL evaluates snippets on a background thread. `runComposeUiTest` usually handles its own thread management, but if you encounter this, try wrapping your code in a `SwingUtilities.invokeLater` (for Desktop) if applicable, though
`runComposeUiTest` should be sufficient.
