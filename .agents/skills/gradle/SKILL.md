---
name: gradle
description: >
  Provides authoritative guidance for ALL Gradle operations: executing builds, running tests with surgical filtering, introspecting project structure, creating modules, and diagnosing failures;
  ALWAYS use instead of raw shell `./gradlew` for build execution, test runs, task introspection, module creation, performance audits, and documentation research.
  Do NOT use for dependency graph auditing/updates (use `managing_gradle_dependencies`) or dependency/plugin/Gradle source exploration (use `exploring_dependency_sources`).
license: Apache-2.0
metadata:
  author: https://github.com/rnett/gradle-mcp
  version: "4.0"
---

# Authoritative Gradle Build Execution, Testing & Project Introspection

Executes builds, runs tests with high-precision filtering, introspects project structure, and diagnoses failures using managed orchestration and structured diagnostics.

## Constitution

- **ALWAYS** use the `gradle` tool instead of `./gradlew` via shell.
- **ALWAYS** provide absolute paths for `projectRoot`.
- **ALWAYS** prefer foreground execution (default) unless the task is persistent (e.g., servers) or extremely long-running (>2 minutes), or you explicitly intend to perform independent research while it proceeds.
- **ALWAYS** use `captureTaskOutput` when you need the isolated output of a specific task (e.g., `help`, `projects`, `tasks`, `properties`, `dependencies`).
- **STRONGLY PREFERRED**: Use `query_build` for all diagnostics. It is more token-efficient than reading raw console logs and provides structured access to failures, problems, and per-test output.
- **ALWAYS** use `query_build` with `kind="TESTS"` and `query="FullTestName"` to access full test output and stack traces.
- **NEVER** use `taskPath` or `captureTaskOutput` to investigate specific test failures; these provide the overall task log which is often truncated and lacks per-test isolation. Per-test output (via `query`) is authoritative and includes
  full stack traces.
- **NEVER** use `--rerun-tasks` unless investigating project-wide cache-specific corruption; prefer `--rerun` for individual tasks.
- **NEVER** guess task names or options; use the `help --task <name>` command for authoritative documentation.
- **NEVER** leave background builds running; use `stopBuildId` to release resources when finished.
- **ALWAYS** prefer Kotlin DSL (`.kts`) unless the project explicitly uses Groovy.
- **ALWAYS** use lazy APIs (e.g., `tasks.register<MyTask>("myTask")`) instead of eager APIs (e.g., `tasks.create<MyTask>("myTask")`) to maintain configuration performance.
- **ALWAYS** use version catalogs (`libs.versions.toml`) for dependency management when present.
- **ALWAYS** use `gradle_docs` for authoritative documentation lookup instead of generic web searches.
- **ALWAYS** check for existing conventions in the current project before proposing changes.
- **ALWAYS** use safe navigation (`?.url?.toString()`) and provide fallback values when accessing `ArtifactRepository` URLs in Gradle init scripts or plugins to prevent `NullPointerException`.
- **ALWAYS** use `:properties --property <name>` for surgical property extraction.

## Directives

### Authoritative Task Path Syntax

Gradle uses two ways to identify tasks from the command line. Precision prevents running redundant tasks in multi-project builds.

#### Task Selectors (Recursive Execution)

Providing a task name **without a leading colon** (e.g., `test`, `build`) acts as a selector. Gradle executes that task in **every project** (root and all subprojects) that contains a task with that name.

- **Example**: `gradle(commandLine=["test"])` -> Executes `test` in **all** projects.

#### Absolute Task Paths (Targeted Execution)

Providing a task path **with a leading colon** (e.g., `:test`, `:app:test`) targets a **single specific project**.

- **Root Project Only**: Use a single leading colon. `gradle(commandLine=[":test"])` -> Root project ONLY.
- **Subproject Only**: Use the subproject name(s) separated by colons. `gradle(commandLine=[":app:test"])` -> ':app' subproject ONLY.

### Authoritative Test Selection (`--tests`)

The `--tests` flag supports powerful, high-precision filtering:

- **Exact Class**: `--tests com.example.MyTest`
- **Exact Method**: `--tests com.example.MyTest.myTestMethod`
- **Wildcard Method**: `--tests com.example.MyTest.test*` (All methods starting with 'test')
- **Package Filter**: `--tests com.example.service.*` (All tests in the 'service' package)
- **Class Prefix**: `--tests *IntegrationTest` (All classes ending in 'IntegrationTest')
- **Character Wildcard**: `--tests com.example.Test?` (Matches Test1, TestA, etc.)
- **Multi-Filter**: `gradle(commandLine=["test", "--tests", "ClassA", "--tests", "ClassB"])`

Patterns match against the **fully qualified name** of the test class or method.

### Foreground vs. Background Execution

- **ALWAYS use foreground for authoritative runs**: If you intend to wait for a result, ALWAYS use foreground execution. It provides superior progressive disclosure and simpler control flow.
- **Background ONLY for persistent tasks**: Use `background: true` ONLY for tasks that must remain active (e.g., `bootRun`, continuous builds) or when you intentionally intend to perform independent research while the build proceeds.
- **Foreground is safe**: Do not fear running high-output suites in the foreground. The `gradle` tool uses progressive disclosure to provide concise summaries and structured results, keeping session history clean.

### `captureTaskOutput` Usage

Use `captureTaskOutput` when you need clean, isolated output from a specific task without Gradle's general console noise. This is ideal for introspection tasks:

- `captureTaskOutput: ":projects"` - Clean project list
- `captureTaskOutput: ":app:tasks"` - Task list for a specific project
- `captureTaskOutput: ":help"` - Documentation for a specific task
- `captureTaskOutput: ":properties"` - Single property extraction
- `captureTaskOutput: ":app:dependencyInsight"` - Dependency resolution path

### `gradle_docs` Tag Syntax

Use `gradle_docs` for authoritative documentation. Always scope with tags:

| Tag                  | Section                                            |
|----------------------|----------------------------------------------------|
| `tag:userguide`      | Official Gradle User Guide                         |
| `tag:dsl`            | Gradle DSL Reference (Groovy and Kotlin DSL)       |
| `tag:javadoc`        | Gradle Java API Reference                          |
| `tag:samples`        | Official Gradle samples and examples               |
| `tag:release-notes`  | Version-specific release insights                  |
| `tag:best-practices` | Official best practices and performance guidelines |

Explore sections with `path="."`. Search scoped with `tag:<section> <term>`.

### Idiomatic DSL Patterns

- **Prefer `register` over `create` (Lazy APIs)**: Use `tasks.register<MyTask>("myTask")` to avoid eager task configuration.
- **Use Type-Safe Accessors**: Prefer `tasks.test { ... }` or `tasks.named<Test>("test") { ... }` over `tasks.getByName("test")`.
- **Use Lazy Properties**: Employ `Property<T>` and `Provider<T>` APIs for late binding and configuration cache compatibility.
- **Use Version Catalogs**: Centralize dependencies in `gradle/libs.versions.toml`.
- **Avoid `allprojects`/`subprojects`**: These blocks create tight coupling; use convention plugins and apply them selectively.
- **Enable Configuration Cache**: Ensure build logic avoids accessing the `Project` object inside task actions.
- **Use Specific Annotations**: Properly label task properties with `@Input`, `@OutputFiles`, `@Internal`, etc.
- **Minimize Logic in Build Scripts**: Move complex logic into convention plugins or `build-logic`.

### Resource Management

- Use `query_build()` without arguments to view the build dashboard and ensure no orphaned background builds are consuming system resources.
- Set `invocationArguments: { envSource: "SHELL" }` if Gradle cannot find expected env vars (e.g., `JAVA_HOME`).

### Diagnostic Inspection (See References)

For comprehensive guidance on using `query_build` and `wait_build` for diagnostics, including JSON examples for every inspection mode (DASHBOARD, SUMMARY, FAILURES, PROBLEMS, TASKS, TESTS, CONSOLE, PROGRESS), refer
to: [query_build Diagnostics Reference](references/query_build_diagnostics.md).

## Workflows

### Running a Foreground Build

1. Identify the task(s) to run (e.g., `["clean", "build"]`).
2. Call `gradle(commandLine=["...", "..."])`.
3. If the build fails, the tool returns a high-signal failure summary. Use `query_build` with the `buildId` for deeper diagnostics via [query_build Diagnostics Reference](references/query_build_diagnostics.md).

### Running Specific Tests

1. Identify the project path (e.g., `:app`) and the test filter (e.g., `com.example.MyTestClass*`).
2. Call `gradle(commandLine=[":app:test", "--tests", "com.example.MyTest"])`.
3. If failures are reported, use `query_build` to get detailed test output.

### Orchestrating Background Jobs

1. Start the build with `background: true` to receive a `BuildId`.
2. Use `wait_build(buildId=ID, timeout=..., waitFor=...)` to block until a specific state or log pattern is reached.
3. Use `query_build()` (no arguments) to manage active jobs in the dashboard.
4. Stop the job using `gradle(stopBuildId=ID)` when finished.

### Introspecting Project Structure

1. Run `gradle(commandLine=[":projects"], captureTaskOutput=":projects")` to map the multi-project hierarchy.
2. Run `gradle(commandLine=[":app:tasks", "--all"], captureTaskOutput=":app:tasks")` to discover runnable tasks.
3. Run `gradle(commandLine=[":help", "--task", "test"], captureTaskOutput=":help")` for task-specific documentation.
4. Run `gradle(commandLine=[":properties", "--property", "version"], captureTaskOutput=":properties")` for surgical property extraction.
5. For detailed dependency resolution paths: `gradle(commandLine=[":app:dependencyInsight", "--dependency", "slf4j-api", "--configuration", "compileClasspath"], captureTaskOutput=":app:dependencyInsight")`.

### Creating a New Module

1. Map the project structure: `gradle(commandLine=[":projects"], captureTaskOutput=":projects")` to find the correct parent path.
2. Create directory structure: `New-Item -ItemType Directory -Force -Path "<module-name>/src/main/kotlin"`.
3. Add to `settings.gradle.kts`: Append `include(":<module-name>")`.
4. Create `build.gradle.kts` with idiomatic patterns (apply convention plugins, set up standard configuration).
5. Verify: `gradle(commandLine=[":<module-name>:tasks"], captureTaskOutput=":<module-name>:tasks")`.

### Performance Audit

1. Check configuration cache status: `gradle(commandLine=[":help", "--configuration-cache"])`.
2. Analyze task compatibility and identify violations.
3. Propose fixes: migrate to lazy APIs (`Property<T>`, `Provider<T>`) or use `@Internal`/`@Input` annotations correctly.
4. Verify against latest guidance: `gradle_docs(query="tag:best-practices", projectRoot="/path/to/project")`.

### Documentation Research

1. Search the user guide: `gradle_docs(query="tag:userguide <term>", projectRoot="/path/to/project")`.
2. Navigate the DSL reference: `gradle_docs(path="dsl/org.gradle.api.Project.html", projectRoot="/path/to/project")`.
3. Check for breaking changes: `gradle_docs(query="tag:release-notes", version="8.6")`.
4. Find best practices: `gradle_docs(query="tag:best-practices dependency management", projectRoot="/path/to/project")`.
5. Search for samples: `gradle_docs(query="tag:samples toolchains", projectRoot="/path/to/project")`.
6. Search javadocs: `gradle_docs(query="tag:javadoc Project", projectRoot="/path/to/project")`.

### Investigating Test Failures

1. Identify the `BuildId` from the build result.
2. Use `query_build(buildId=ID, kind="TESTS", outcome="FAILED")` to list all failed tests.
3. Use `query_build(buildId=ID, kind="TESTS", query=TNAME)` to see the full output and stack trace for a specific test.
4. **DO NOT** use `taskPath` or `captureTaskOutput` for test failure investigation.

## When to Use

- **Core Lifecycle Execution**: When you need to execute standard Gradle tasks (`build`, `assemble`, `clean`) with reliable, parseable output.
- **Test Execution & Diagnostics**: When running tests with `--tests` filtering, isolating failures, or retrieving full stack traces.
- **Introspection & Mapping**: When mapping multi-module project hierarchies, discovering runnable tasks, or auditing build configuration.
- **Surgical Property Inspection**: When extracting a specific property value (artifact version, build directory) for use in a subsequent task.
- **Persistent Development Processes**: When starting dev servers (`bootRun`) or continuous builds where background management is required.
- **Task-Specific Information Retrieval**: When you need isolated output from a single task (`help`, `projects`, `tasks`) without build noise.
- **Build Failure Diagnostics**: When performing deep-dive analysis of task failures, problems, or compilation errors.
- **New Module Creation**: When adding a new project or module to a multi-project build.
- **Build Logic Refactoring**: When cleaning up complex build scripts or creating convention plugins.
- **Performance Troubleshooting**: When builds are slow or failing during the configuration phase.
- **Documentation & DSL Research**: When looking up official Gradle syntax, user guide topics, or release notes.

## Examples

### Run build in all projects

Tool: `gradle`

```json
{
  "commandLine": ["build"]
}
// Reasoning: Task selector (no colon) verifies build health across the entire multi-project structure.
```

### Run a single test class in a specific subproject

Tool: `gradle`

```json
{
  "commandLine": [":app:test", "--tests", "com.example.service.MyServiceTest"]
}
// Reasoning: Absolute task path with exact class filter for the fastest possible feedback loop.
```

### Inspect help output for a specific task

Tool: `gradle`

```json
{
  "commandLine": [":app:help", "--task", "test"],
  "captureTaskOutput": ":app:help"
}
// Reasoning: Using captureTaskOutput to retrieve clean, isolated documentation.
```

### List all sub-projects in the build

Tool: `gradle`

```json
{
  "commandLine": [":projects"],
  "captureTaskOutput": ":projects"
}
// Reasoning: Using captureTaskOutput to retrieve the project hierarchy list without startup noise.
```

### Surgically inspect the 'version' property

Tool: `gradle`

```json
{
  "commandLine": [":properties", "--property", "version"],
  "captureTaskOutput": ":properties"
}
// Reasoning: Using --property to isolate a single value and avoid retrieving thousands of unrelated properties.
```

### Analyze a specific dependency conflict

Tool: `gradle`

```json
{
  "commandLine": [
    ":app:dependencyInsight",
    "--dependency",
    "com.google.guava:guava",
    "--configuration",
    "runtimeClasspath"
  ],
  "captureTaskOutput": ":app:dependencyInsight"
}
// Reasoning: Using dependencyInsight to isolate the resolution path for a specific artifact.
```

### Start a dev server and wait for readiness

Tool: `gradle`

```json
// Step 1: Start the server in the background
{
  "commandLine": [":app:bootRun"],
  "background": true
}
// Response: { "buildId": "build_123" }

// Step 2: Wait for readiness signal
{
  "buildId": "build_123",
  "timeout": 60,
  "waitFor": "Started Application"
}
// Reasoning: Background orchestration allows the server to remain active while waiting for readiness.
```

### Search official Gradle documentation

Tool: `gradle_docs`

```json
{
  "query": "tag:dsl signing plugin",
  "projectRoot": "/absolute/path/to/project"
}
// Reasoning: Using the DSL tag to find authoritative syntax for the signing plugin configuration.
```

### Create a new sub-project module

Tool: `run_shell_command`

```json
{
  "command": "New-Item -ItemType Directory -Force -Path subproject/src/main/kotlin"
}
// Reasoning: Creating the standard directory structure for a Kotlin JVM project using correct PowerShell syntax.
```

### List all failed tests in a build

Tool: `query_build`

```json
{
  "buildId": "build_abc123",
  "kind": "TESTS",
  "outcome": "FAILED"
}
// Reasoning: Isolating only the failures from a large test suite for efficient triage.
```

## Troubleshooting

- **Build Not Found**: If a `BuildId` is not recognized, it may have expired from the recent history cache. Check the dashboard (`query_build()`) for valid active and historical IDs.
- **Task Output Not Captured**: Ensure the path provided to `captureTaskOutput` matches exactly one of the tasks in the `commandLine`.
- **Missing environment variables**: Set `invocationArguments: { envSource: "SHELL" }` if Gradle cannot find expected env vars (e.g., `JAVA_HOME`).

## Resources

- [query_build Diagnostics Reference](references/query_build_diagnostics.md) — Complete diagnostic patterns for DASHBOARD, SUMMARY, FAILURES, PROBLEMS, TASKS, TESTS, CONSOLE, and PROGRESS.
- [Background Monitoring Patterns](references/background_monitoring.md)
- [Authoritative Diagnostic Tasks](references/diagnostic_tasks.md) — Built-in introspection tasks.
- [Best Practices Snapshot](references/best_practices.md) — High-level best practices; always verify with `gradle_docs`.
- [Common Build Patterns](references/common_build_patterns.md) — Idiomatic patterns for multi-project builds, convention plugins, and task registration.
- [Official Gradle Documentation Research](references/gradle_docs_research.md) — Guidance on using `gradle_docs` for authoritative documentation.
