---
name: interacting_with_project_runtime
description: >
  Executes Kotlin code interactively within the project's full JVM classpath.
  Use when you need to RUN code: verify runtime behavior, experiment with logic, or render Compose UI previews.
  Do NOT use to understand an API's shape or signature — read its source with `exploring_dependency_sources` instead.
license: Apache-2.0
metadata:
  author: https://github.com/rnett/gradle-mcp
  version: "2.3"
---

# Authoritative Project Runtime Interaction

Runs Kotlin code interactively within the project's exact JVM classpath — for when you need to execute, not just read.

## Constitution

- **The core decision rule**: If the question is *"what does this API look like or how does it work?"* → use `search_dependency_sources` / `read_dependency_sources` (read the source). If the question is *"what happens when I run this?"* →
  use `kotlin_repl`.
- **NEVER** start a REPL session to learn about an API. Reading indexed sources is instantaneous, shows the full implementation with all overloads, and requires no JVM process.
- **ALWAYS** use `kotlin_repl` instead of a standalone Kotlin REPL for project-aware interaction.
- **ALWAYS** provide absolute paths for `projectRoot`.
- **ALWAYS** start a REPL session with the correct `projectPath` and `sourceSet` (e.g., `main`, `test`).
- **ALWAYS** restart the REPL (`stop` then `start`) after modifying project source code to pick up changes in the classpath.
- **ALWAYS** use the `responder` API for rich output (images, markdown) to improve diagnostic visibility.
- **NEVER** leave a REPL session running indefinitely; use `stop` when finished.
- **REPL Session Management**: Explicitly terminate previous REPL sessions in `ReplTools` before starting new ones when session IDs are regenerated. This prevents leaking worker processes and ensures stable session management during
  concurrent or sequential tool calls.

## Directives

- **Read to understand, run to verify**: If you need to understand what an API does — its signature, parameters, overloads, or implementation — read its source via `search_dependency_sources` / `read_dependency_sources`. Only reach for the
  REPL once you know what you want to call and need to observe actual runtime output.
- **ALWAYS use project-aware REPL**: Only the `kotlin_repl` tool provides full access to the project's exact classpath, dependencies, and source sets. NEVER attempt to use standalone runners for project-internal logic.
- **Identify the environment**: When starting a session, ALWAYS ensure you select the appropriate `projectPath` (e.g., `:app`) and `sourceSet` (e.g., `main` for application code, `test` for test utility access).
- **Pick up source changes**: The REPL uses a static snapshot of the classpath. If you change project code, you MUST `stop` and then `start` the session again to pick up the updated classes.
- **Utilize the `responder`**: ALWAYS use `responder.render()` or specialized methods (`markdown`, `image`, `html`) to return rich content.
- **Import necessary classes**: ALWAYS provide explicit imports for project-specific and library classes.
- **Use `envSource: SHELL` if environment variables are missing**: If the REPL fails to find expected environment variables (e.g., `JAVA_HOME` or specific JDKs), it may be because the host process started before the shell environment was
  fully loaded. Set `env: { envSource: "SHELL" }` when calling `start` to force a new shell process to query the environment.
- **Resolve `{baseDir}` manually**: If your environment does not automatically resolve the `{baseDir}` placeholder in reference links, treat it as the absolute path to the directory containing this `SKILL.md` file.

## When to Use (you need to RUN code)

- **Behavior Verification**: You know the API, you've written the call, and you need to observe the actual runtime output or side-effects.
- **Logic Prototyping**: Experimenting with an algorithm or snippet of your own code before committing it to source.
- **Visual Component Auditing**: Rendering Compose UI components to images for visual review.
- **Dynamic Data Probing**: One-off data transformations using your project's existing utilities where the output depends on runtime state.

## When NOT to Use (you need to READ source instead)

Ask yourself: *"Am I trying to understand this API, or run it?"*

If you're trying to understand it — what methods it has, what its parameters are, how it's implemented — **stop and use `exploring_dependency_sources` first**. The REPL cannot tell you what you don't already know to ask; source reading can.
Examples of what belongs in source reading, not the REPL:

- "What methods does `SomeClass` have?" → `search_dependency_sources` DECLARATION search
- "What does this function do internally?" → `read_dependency_sources`
- "What are the parameters / overloads of this function?" → `read_dependency_sources`
- "Does this library have a class for X?" → `search_dependency_sources` FULL_TEXT or DECLARATION search

## Workflows

### Starting an Authoritative Session

1. Identify the project module (e.g., `:app`) and source set (e.g., `main`).
2. Call `kotlin_repl(command="start")`.
3. Optionally provide `env` for environment variables or `additionalDependencies` if you need external libraries not currently in the project.

### Probing Code & State

1. Use `kotlin_repl(command="run")` with your Kotlin code.
2. Use `responder.render()` for rich diagnostics.
3. Review the returned text or image content.

### Lifecycle Management

1. Use `kotlin_repl(command="stop")` once your investigation is complete to release system resources.

## Examples

### Probing a project utility function

```json
// Start the session
{
  "command": "start",
  "projectPath": ":my-project",
  "sourceSet": "main"
}

// Execute the probe
{
  "command": "run",
  "code": "import com.example.utils.MyHelper\nMyHelper.calculateSum(1, 2)"
}
// Reasoning: Using kotlin_repl to verify a utility function in the context of the main source set.
```

### Visualizing a UI Component

```kotlin
import androidx.compose.ui.test.*
import com.example.ui.MyComposable

runComposeUiTest {
    setContent { MyComposable() }
    val bitmap = onRoot().captureToImage()
    responder.render(bitmap)
}
// Reasoning: Using the responder API to retrieve a high-resolution image of a Compose component.
```

## Troubleshooting

- **REPL Not Started**: You must call `start` successfully before calling `run`.
- **ClassNotFoundException**: Ensure the project has been built at least once and that you have selected the correct `sourceSet` (e.g., `test` if the class is in `src/test/kotlin`).
- **Changes Not Reflected**: If your code changes aren't appearing, `stop` and `start` the REPL to refresh the classpath.
