---
name: managing_gradle_dependencies
description: >
  Audits and manages Gradle dependency graphs with high-resolution update checks, transitive tree analysis, and Maven Central discovery;
  use for dependency auditing, finding stable updates, and resolving GAV coordinates.
  Do NOT use for exploring dependency source code (use `exploring_dependency_sources`) or running builds/tests (use `gradle`).
license: Apache-2.0
metadata:
  author: https://github.com/rnett/gradle-mcp
  version: "3.4"
---

# Authoritative Dependency Intelligence & Maven Central Search

Audits project dependencies, performs high-resolution update checks, and discovers new libraries on Maven Central with powerful, integrated search tools.

## Constitution

- **ALWAYS** use `inspect_dependencies` for querying project dependency information instead of raw Gradle tasks.
- **ALWAYS** provide absolute paths for `projectRoot`.
- **ALWAYS** use `updatesOnly: true` to quickly identify available library updates.
- **ALWAYS** use `lookup_maven_versions` to find exact GAV coordinates for new libraries.
- **NEVER** add a dependency to a project without verifying its authoritative version and existence on Maven Central.
- **ALWAYS** use the `projectPath` argument to target specific modules in multi-project builds.

## Directives

- **Identify authoritative paths**: ALWAYS use the Gradle project path (e.g., `:app`) when querying dependencies.
- **Inspect plugins and build scripts**: Build script dependencies (like plugins) are automatically included in `inspect_dependencies` output under configurations prefixed with `buildscript:` (e.g. `buildscript:classpath`).
- **Monitor for updates**: ALWAYS use `updatesOnly: true` in `inspect_dependencies` to retrieve a flat, high-signal report of available library updates: `group:artifact: current → latest` with the project paths where each dep is used.
  Configuration and source-set detail is intentionally omitted; use `inspect_dependencies` with a specific `dependency` filter if that detail is needed.
- **Target dependencies surgically**: Use the `dependency` parameter in `inspect_dependencies` to target a single library with a full-string Kotlin regex over `group:name:version[:variant]` coordinates.
- **Efficient Transitive Isolation**: When isolating a single library, filter the flattened list of resolved components using the dependency filter rather than traversing the dependency graph. This naturally and efficiently excludes
  transitive dependencies that do not match the targeted filter.
- **Discover libraries surgically**: ALWAYS use `lookup_maven_versions` to check the version history of an existing artifact.
- **Use `gradle` for diagnostics**: For built-in tasks like `dependencyInsight`, ALWAYS use the `gradle` tool with `captureTaskOutput`.
- **Audit full trees**: ALWAYS use `onlyDirect: false` in `inspect_dependencies` when you need to visualize the complete transitive dependency graph.

## When to Use

- **Dependency Tree Auditing**: When you need to visualize the full dependency graph for a specific project, configuration, or source set.
- **Automated Update Detection**: When performing maintenance and you want a concise report on available stable or pre-release updates.
- **Precision Artifact Discovery**: When looking for new libraries on Maven Central and you need to find exact GAV coordinates or explore an artifact's full version history.
- **Version Conflict Resolution**: When you need to identify why a specific version of a library is being resolved and look for compatible alternatives.
- **Targeted Audit**: When you only care about a specific library and want to bypass the cost of a full project resolution.

## Workflows

### 1. Auditing Dependencies

1. Identify the project module (e.g., `:app`).
2. Call `inspect_dependencies(projectPath=":app")`.
3. Optionally filter by `configuration` (e.g., `runtimeClasspath`) or `sourceSet` (e.g., `test`).

### 2. Checking for Stable Updates

1. Call `inspect_dependencies(updatesOnly=true, stableOnly=true)`.
2. Review the flat list of upgradeable dependencies. Each entry shows `group:artifact: current → latest` and the project paths where it is used.

### 3. Discovering New Libraries

1. Use `lookup_maven_versions(coordinates="group:artifact")` to see all available versions for a specific library.

### 4. Targeted Dependency Inspection

1. Identify the dependency you want to check (e.g., `org.mongodb:mongodb-driver-sync`).
2. Call `inspect_dependencies(dependency="^org\\.mongodb:mongodb-driver-sync(:.*)?$")`.
3. The report will be focused ONLY on that library across all matched configurations.

### 5. Adding a New Dependency

1. **Search Maven Central**: Use `lookup_maven_versions(coordinates="group:artifact")` to find the artifact and its latest version.
2. **Update Version Catalog**: Add the dependency coordinates to `gradle/libs.versions.toml`:
   ```toml
   [versions]
   my-lib = "X.Y.Z"

   [libraries]
   my-lib = { group = "com.example", name = "my-lib", version.ref = "my-lib" }
   ```
3. **Apply to `build.gradle.kts`**: Use the type-safe catalog accessor (e.g., `implementation(libs.my.lib)`) in the appropriate dependency configuration.
4. **Verify Resolution**: Run `inspect_dependencies(fresh: true)` to confirm the dependency resolves correctly.

#### Example: Adding a dependency to a subproject

```json
// Step 1: Discover the library
{
  "coordinates": "com.squareup.retrofit2:retrofit"
}
// Step 2: Update libs.versions.toml with the version and library entry
// Step 3: Add `implementation(libs.retrofit)` to the subproject's build.gradle.kts
// Step 4: Verify
{
  "projectPath": ":app",
  "dependency": "^com\\.squareup\\.retrofit2:retrofit(:.*)?$"
}
// Reasoning: Adding the Retrofit library to the 'app' module with full resolution verification.
```

### 6. Verifying Plugin Dependencies

Build script dependencies (plugins) are automatically reported under `buildscript:` configurations. To specifically verify plugin resolution:

1. Call `inspect_dependencies(sourceSetPath=":buildscript")` for the root project, or `sourceSetPath=":app:buildscript"` for a subproject.
2. Review the `buildscript:classpath` configuration for plugin dependencies.
3. Use `fresh: true` if plugins were recently added or updated.

#### Example: Verifying a specific plugin

```json
{
  "sourceSetPath": ":buildscript",
  "dependency": "^org\\.jetbrains\\.kotlin:kotlin-gradle-plugin(:.*)?$"
}
// Reasoning: Verifying the Kotlin plugin is properly resolved in the buildscript classpath.
```

## Examples

### List dependencies for a specific module

```json
{
  "projectPath": ":app"
}
// Reasoning: Auditing the direct and transitive dependencies of the 'app' module to understand its runtime footprint.
```

### Check for updates for a specific library

```json
{
  "dependency": "^org\\.jetbrains\\.kotlinx:kotlinx-coroutines-core(:.*)?$",
  "updatesOnly": true
}
// Reasoning: Surgically checking if a specific library has available updates.
```

### Check for stable updates across the project

```json
{
  "updatesOnly": true,
  "stableOnly": true
}
// Reasoning: Performing a high-signal update audit that ignores unstable pre-release versions.
```

### List all versions of a specific library

```json
{
  "coordinates": "org.jetbrains.kotlinx:kotlinx-serialization-json"
}
// Reasoning: Retrieving the full version history of an artifact to identify the latest stable or specific version required.
```

## Troubleshooting

- **Dependency Not Found**: Verify the `projectPath` using the `projects` task in the `gradle` skill.
- **Update Not Showing**: If a known update is missing, ensure `stableOnly` is set correctly and check if a `versionFilter` is active.
- **[UPDATE CHECK SKIPPED]**: This annotation means the dep was in scope for update checking but its resolution genuinely failed — it does NOT appear for dependencies intentionally excluded from the update-check scope (e.g., transitive deps
  when `onlyDirect=true`, or deps excluded by a `dependency` filter).
- **Maven Search No Results**: Use broader search terms or verify the `group:artifact` format for version searches.
- **Missing environment variables**: Set `invocationArguments: { envSource: "SHELL" }` if Gradle cannot find expected env vars (e.g., `JAVA_HOME`).
