---
name: verifying_compose_ui
description: >
  Visually verifies Compose UI components by rendering @Composable/@Preview functions to images from the project's JVM runtime;
  STRONGLY PREFERRED for rapid UI iteration and visual feedback on any composable.
  Do NOT use for build lifecycle tasks or dependency auditing.
license: Apache-2.0
metadata:
  author: https://github.com/rnett/gradle-mcp
  version: "2.2"
---

## ⚠️ FUNDAMENTAL ANDROID LIMITATION

**IMPORTANT: `runComposeUiTest` and image capture methods (`node.captureToImage()`) are NOT supported on Android and CANNOT work.**

### Why This Cannot Work

The `runComposeUiTest` function requires a JVM-based test runtime with desktop Compose rendering (via Skiko on JVM/Desktop). Android's ART (Android Runtime) does not support the desktop Compose testing APIs, and image capture via
`captureToImage()` relies on desktop-specific rendering pipelines that are fundamentally incompatible with Android.

### The Solution: Use a JVM Target

**For visual verification of Composables, you MUST use a JVM or Desktop target source set.** This is not a workaround—it is the only supported method.

Recommended approach:

1. **Put your Composables in a common source set** (`commonMain`) that is shared across all targets
2. **Create or use a JVM target** (e.g., `jvmMain`, `desktopMain`) that depends on `commonMain`
3. **Run the REPL on the JVM target** (`sourceSet: "jvmMain"` or `sourceSet: "jvmTest"`)

This is the standard KMP pattern and allows you to verify your UI code without needing an Android device or emulator.

### What WILL NOT Work

- ❌ Running the REPL with `sourceSet: "androidMain"`
- ❌ Running the REPL with `sourceSet: "androidTest"`
- ❌ Any attempt to use `runComposeUiTest` on Android
- ❌ Any attempt to use `captureToImage()` on Android

### What WILL Work

- ✅ Running the REPL with `sourceSet: "jvmMain"` or `sourceSet: "jvmTest"`
- ✅ Running the REPL with `sourceSet: "desktopMain"` or `sourceSet: "desktopTest"`
- ✅ Using `runComposeUiTest` with `captureToImage()` on JVM/Desktop targets

---

# Authoritative Compose UI Preview & Visual Verification

Visually verifies and renders any @Composable or @Preview directly to high-quality images from the project-aware REPL for instant, authoritative visual feedback.

## Constitution

- **ALWAYS** use `kotlin_repl` to render Compose components instead of running the full application for visual checks.
- **ALWAYS** provide absolute paths for `projectRoot`.
- **ALWAYS** use `node.captureToImage()` and `responder.render(bitmap)` to return the visual output.
- **ALWAYS** ensure the correct Compose UI testing dependencies are on the classpath, using `additionalDependencies` if necessary.
- **NEVER** assume a UI component renders correctly without visual verification.
- **ALWAYS** search for existing `@Preview` functions in the project source code before creating new ones.

## Directives

- **ALWAYS provide absolute `projectRoot`**: Ensure `projectRoot` is an **absolute file system path** for all `kotlin_repl` calls.
- **Ensure dependencies**: ALWAYS ensure Compose UI testing dependencies (e.g., `androidx.compose.ui:ui-test-junit4`) are on the classpath.
- **Note on versions**: ALWAYS check your project's version catalog and existing tests for the correct imports for `runComposeUiTest`.
- **Render as image**: ALWAYS use `node.captureToImage()` and `responder.render(bitmap)` to return the visual output.
- **Kotlin Multiplatform (KMP) Note**: The `kotlin_repl` currently only supports **JVM-based** source sets. ALWAYS select a JVM or Desktop target source set for visual checks.
- **Use `envSource: SHELL` if environment variables are missing**: Set `env: { envSource: "SHELL" }` (REPL start) or `invocationArguments: { envSource: "SHELL" }` (Gradle tasks) if expected env vars (e.g., `JAVA_HOME`) are not found.

## When to Use

- **Rapid UI Prototyping & Iteration**: When you need to see the visual result of a Composable change instantly without the latency of a full application launch.
- **Authoritative @Preview Verification**: When you want to verify the visual correctness of existing `@Preview` functions.
- **Complex UI State & Interaction Testing**: When you need to capture visual state before and after interactions (like clicks or state changes).
- **Multi-Configuration Visual Auditing**: When checking how a component renders across different data states or configurations (e.g., different view models or mock data).

## Workflows

### 1. Identifying the Component

1. Find the fully qualified name of the `@Composable` or `@Preview` function.
2. Search for existing previews in the source code via `grep_search(pattern="@Preview")`.

### 2. Orchestrating the Session

1. Start the REPL with the `test` source set (preferred) or `main` with `additionalDependencies`.
2. Use `kotlin_repl(command="start")`.
3. Use `kotlin_repl(command="run")` to execute the rendering script.

### 3. Rendering & Verifying

1. Execute a script that uses `runComposeUiTest` to render and capture the component.
2. Inspect the returned image for visual correctness.

## Examples

### Viewing a simple Composable

```kotlin
import androidx.compose.ui.test.*
import com.example.ui.MyButton

runComposeUiTest {
    setContent {
        MyButton(text = "Click Me")
    }
    val node = onRoot()
    responder.render(node.captureToImage())
}
// Reasoning: Using kotlin_repl to render a specific component and retrieve its visual representation via the responder API.
```

### Viewing an existing @Preview

```kotlin
import androidx.compose.ui.test.*
import com.example.ui.MyButtonPreview // Top-level preview function

runComposeUiTest {
    setContent {
        MyButtonPreview()
    }
    val node = onRoot()
    responder.render(node.captureToImage())
}
// Reasoning: Reusing an existing authoritative preview function to verify its visual correctness.
```

### Capturing State Transitions

```kotlin
import androidx.compose.ui.test.*
import com.example.ui.MyCounter
import com.example.viewmodel.MyViewModel

runComposeUiTest {
    val viewModel = MyViewModel()
    setContent {
        MyCounter(viewModel)
    }

    // Capture state before interaction
    responder.render("State before: ${viewModel.count}")
    responder.render(onRoot().captureToImage())

    // Perform interaction
    onNodeWithText("Increment").performClick()

    // Capture state after interaction
    responder.render("State after: ${viewModel.count}")
    responder.render(onRoot().captureToImage())
}
// Reasoning: Capturing visual snapshots before and after an interaction to verify state-dependent UI changes.
```

## Troubleshooting

- **No Image Returned**: Ensure you are calling `responder.render(bitmap)`.
- **ClassNotFoundException**: Check if you have the correct imports and that the required testing dependencies are on the classpath.
- **Empty Image**: If the Composable is empty or has zero size, the image will be empty. Verify your Composable's modifiers.

## Resources

- [Troubleshooting]({baseDir}/references/troubleshooting.md)
