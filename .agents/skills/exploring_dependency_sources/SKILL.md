---
name: exploring_dependency_sources
description: >
  Reads and searches source code across ALL scopes: external library dependencies, plugins (buildscript), and Gradle Build Tool internal source code;
  use whenever you need to UNDERSTAND an API — its shape, signature, parameters, overloads, or implementation — before writing any code that calls it;
  covers project dependencies (via project/configuration/source set scope), plugins (via `sourceSetPath=":buildscript"`), and Gradle internals (via `gradleSource: true`).
  Prefer this over the REPL for all API research; reading source is instantaneous and complete.
  Do NOT use for project source code (use grep/tilth), Gradle documentation (use `gradle_docs` via the `gradle` skill), or Maven Central discovery (use `managing_gradle_dependencies`).
license: Apache-2.0
metadata:
  author: https://github.com/rnett/gradle-mcp
  version: "2.0"
---

# Authoritative Dependency, Plugin & Gradle Internal Source Exploration

Explores, navigates, and analyzes the internal logic, APIs, and symbol implementations of external libraries, Gradle plugins, and the Gradle Build Tool itself with absolute precision using high-performance, indexed searching.

## Constitution

- **ALWAYS** use `search_dependency_sources` as the primary discovery tool for external library, plugin, and Gradle internal code.
- **ALWAYS** prefer reading source code over interactive REPL exploration for understanding unfamiliar library APIs.
- **ALWAYS** provide absolute paths for `projectRoot`.
- **ALWAYS** use the `{group}/{artifact}` prefix for reading specific files (e.g., `path="org.mongodb/mongodb-driver-sync/org/mongodb/client/MongoClient.kt"`). The `dependency` parameter should only be used to filter the search scope for
  performance when searching across libraries, not as the primary way to specify a path.
- **ALWAYS** escape Lucene special characters (`:`, `=`, `+`, `-`, `*`, `/`) in `FULL_TEXT` searches using a backslash (e.g., `\:`) or double quotes.
- **ALWAYS** use `read_dependency_sources` once a specific file path has been identified via search.
- **ALWAYS** use `fresh: true` if a search returns a `SearchResponse` with an `error` indicating a missing index.
- **BE AWARE** that indexing and extraction failures (e.g., `ZipException`) are propagated and will cause the tool to fail with a descriptive error.
- **NOTE** that the `dependency` filter targets ONLY the specific library version matched, NOT its transitive dependencies.
- **BE AWARE** that buildscript (plugin) dependencies are excluded from `search_dependency_sources` and `read_dependency_sources` by default to reduce noise.
- **ALWAYS** use `sourceSetPath=":buildscript"` (root project) or `sourceSetPath=":app:buildscript"` (subproject) to search or read plugin source code. This targets the virtual `buildscript` source set which aggregates all classpath
  plugins.
- **ALWAYS** use `gradleSource: true` in `search_dependency_sources` to target Gradle's internal engine when probing core Gradle behavior.
- **ALWAYS** scope with a project, configuration, or source set (or use `gradleSource: true`) — unscoped search is no longer supported.
- **ALWAYS** verify against the actual source implementation when researching Gradle internals.
- **NEVER** use generic shell tools like `grep` or `find` to *locate* dependency sources; they reside in remote caches whose paths are not predictable in advance.
- **MAY** use shell tools like `rg` or `ast-grep` to *operate on* a sources root path explicitly returned by `read_dependency_sources` or `search_dependency_sources` in the `Sources root: <path>` header line. Dependency directories inside
  the sources root are symlinks; always pass `--follow` to `rg` (e.g., `rg --follow <pattern> <sources-root>`).

## Directives

### Search Modes

- **DECLARATION**: Best for classes, methods, or interfaces. Matches against the simple name (tokenized for CamelCase) and the full path (exact literal). All declaration searches are **case-sensitive**. Do NOT include keywords like `class`,
  `interface`, or `fun`. Supports exact names, exact FQNs, glob wildcards (e.g., `*`, `**`), and regular expressions. Use `name:` (discovery) or `fqn:` (precision) prefix for field-specific searches.
- **FULL_TEXT**: Best for literal strings, constants, and complex code patterns using Lucene. **Case-insensitive**.
- **GLOB**: Best for finding specific files (XML, properties, etc.) by name or extension. **Case-insensitive**.

Glob wildcards for FQNs: `*` matches one segment, `**` matches multiple. Example: `fqn:org.gradle.*.Project` or `fqn:org.**.Project`.

Regex: Wrap query in `/` for a full regular expression on the `fqn` field. Example: `fqn:/.*\.internal\..*/` to find all internal declarations.

### Scoping

- **Project Dependencies**: Use `search_dependency_sources` with `projectPath`, `configurationPath`, or `sourceSetPath` to scope to project dependency code.
- **Plugins (Buildscript)**: Use `sourceSetPath=":buildscript"` to target plugin source code.
- **Gradle Internals**: Use `gradleSource: true` to target Gradle Build Tool source code.

### Performance

- **Target Libraries Directly**: Use the `dependency` parameter to filter searches to a single library (`group:name:version:variant`, `group:name:version`, `group:name`, or just `group`). This bypasses project-level index merging for
  instantaneous results.
- **Troubleshoot Targeted Searches**: If a targeted search fails, use `inspect_dependencies` first to verify the exact coordinates of the dependency as resolved by Gradle.
- **Refresh Indices**: Use `fresh: true` if project dependencies have recently changed.
- **Use Returned Sources Root**: Every response includes a `Sources root: <absolute-path>` header. Use this path with `rg`, `ast-grep`, or other shell tools for operations not covered by the MCP tools. Always pass `--follow` to `rg` for
  symlinked dependency directories.

### Exploration

- **Explore Packages Authoritatively**: Use `read_dependency_sources` with a dot-separated package path (e.g., `org.gradle.api`) to list its direct symbols and sub-packages.
- **Analyze Implementation**: Use `read_dependency_sources` to retrieve implementation logic. Use `pagination` for large files.
- **Trace Symbols Authoritatively**: When encountering an unknown symbol, use `DECLARATION` search to jump directly to its definition.

## When to Use

> **Decision rule**: If the question is *"what does this API look like or how does it work?"* — use this skill. If you need to *run* code to see what it does at runtime — use `interacting_with_project_runtime` (REPL). Read before you run.

- **API & Symbol Discovery**: Finding implementation, signature, or documentation of a class/interface/method from a dependency, plugin, or Gradle itself.
- **Library Usage Research**: Understanding how to use a library's API by reading its internal implementation.
- **Internal Logic Auditing**: Researching how a dependency or Gradle engine handles specific operations.
- **Resource File Location**: Searching for configuration files (XML, JSON, properties) or metadata packaged within library jars.
- **Constant & Literal Research**: Searching for specific constant values, error strings, or literal keys within external code.
- **Gradle Internal Exploration**: Probing Gradle engine classes (e.g., `org.gradle.api.Project`, `Task`, `DependencyHandler`) to understand internal behavior.
- **Plugin Source Auditing**: Examining plugin implementations to understand how they configure the build at runtime.

## Workflows

### 1. Tracing a Symbol from Project Code

1. Identify the symbol name or fully qualified name from an import.
2. Call `search_dependency_sources(query="<SymbolName>", searchType="DECLARATION", projectPath=":")`.
3. Identify the correct file path from the results.
4. Call `read_dependency_sources(path="<path>", projectPath=":")` to analyze the implementation.

### 2. Discovering API Usage through Source

1. Search for a known entry point (constructor, main class) using `DECLARATION` or `FULL_TEXT`.
2. Once found, use `read_dependency_sources` to read the source.
3. Look for internal calls, helper methods, or factory patterns to understand preferred usage.

### 3. Researching Gradle Internal Engine

1. Search for the class: `search_dependency_sources(query="<ClassName>", searchType="DECLARATION", gradleSource=true)`.
2. Use glob wildcards for subpackage searches: `fqn:org.gradle.*.SomeApi` or `fqn:org.**.SomeApi`.
3. Once identified, read the implementation: `read_dependency_sources(path="org/gradle/...", gradleSource=true)`.
4. Check for breaking changes against specific versions via `gradle_docs` (see `gradle` skill).

### 4. Researching Plugin Source Code

1. Search plugins: `search_dependency_sources(query="<PluginName>", searchType="DECLARATION", sourceSetPath=":buildscript")`.
2. Read plugin implementation: `read_dependency_sources(path="<group>/<artifact>/...", sourceSetPath=":buildscript")`.

### 5. Targeted Search for a Single Library

1. Identify dependency coordinates from `inspect_dependencies` or project files.
2. Call `search_dependency_sources(query="<query>", dependency="<group:artifact>", projectPath=":")`.
3. Results are scoped ONLY to that library for maximum speed and relevance.

### 6. Searching for Constants or Error Codes

1. Identify the constant name or error message snippet.
2. Call `search_dependency_sources(query="<text>", projectPath=":")` (defaults to `FULL_TEXT`).
3. Review matches to find where the value is defined or used.

### 7. Exploring Documentation (Gradle Docs)

For official Gradle documentation (User Guide, DSL, Release Notes), use the `gradle_docs` tool via the `gradle` skill. See [Internal Source Research](references/internal_source_research.md) for authoritative research patterns combining docs
and source.

## Examples

### Search for a specific class definition (project deps)

Tool: `search_dependency_sources`

```json
{
  "query": "JsonConfiguration",
  "searchType": "DECLARATION",
  "projectPath": ":"
}
// Reasoning: DECLARATION search for a class name across both name and FQN fields, scoped to the root project.
```

### Search Gradle internal engine source code

Tool: `search_dependency_sources`

```json
{
  "query": "Project",
  "searchType": "DECLARATION",
  "gradleSource": true
}
// Reasoning: Using gradleSource and DECLARATION search to find the ground-truth implementation of the core Project API.
```

### Search for a specific class within a targeted library

Tool: `search_dependency_sources`

```json
{
  "query": "MongoClient",
  "searchType": "DECLARATION",
  "dependency": "org.mongodb:mongodb-driver-sync",
  "projectPath": ":"
}
// Reasoning: The 'dependency' parameter targets only the 'mongodb-driver-sync' library for a fast, focused search.
```

### Search plugin source code

Tool: `search_dependency_sources`

```json
{
  "query": "KotlinPlugin",
  "searchType": "DECLARATION",
  "sourceSetPath": ":buildscript"
}
// Reasoning: Targeting the buildscript source set to find plugin implementation classes.
```

### Search with FQN glob wildcards (Gradle internals)

Tool: `search_dependency_sources`

```json
{
  "query": "fqn:org.gradle.*.Project",
  "searchType": "DECLARATION",
  "gradleSource": true
}
// Reasoning: Glob wildcard to find Project declarations in any direct sub-package of org.gradle.
```

### Use regular expressions for internal APIs

Tool: `search_dependency_sources`

```json
{
  "query": "fqn:/.*\\.internal\\..*/",
  "searchType": "DECLARATION",
  "gradleSource": true
}
// Reasoning: Regex on the 'fqn' field to find all internal Gradle declarations.
```

### Search with name-specific discovery (CamelCase)

Tool: `search_dependency_sources`

```json
{
  "query": "name:Configuration",
  "searchType": "DECLARATION",
  "projectPath": ":"
}
// Reasoning: The 'name:' prefix finds classes like 'JsonConfiguration' via CamelCase tokenization.
```

### Search for a constant value assignment

Tool: `search_dependency_sources`

```json
{
  "query": "DEFAULT_TIMEOUT_MS \\: 5000",
  "projectPath": ":"
}
// Reasoning: FULL_TEXT (default) with escaped colon to find a specific constant assignment.
```

### Locate a specific file by its exact name

Tool: `search_dependency_sources`

```json
{
  "query": "**/AndroidManifest.xml",
  "searchType": "GLOB",
  "projectPath": ":"
}
// Reasoning: GLOB search to find a specific file by name across the dependency graph.
```

### Read sources from a specific dependency

Tool: `read_dependency_sources`

```json
{
  "path": "org.jetbrains.kotlinx/kotlinx-coroutines-core/kotlinx/coroutines/Job.kt",
  "projectPath": ":"
}
// Reasoning: Reading 'Job.kt' using the recommended `{group}/{artifact}` syntax.
```

### Read a specific Gradle internal class

Tool: `read_dependency_sources`

```json
{
  "path": "org/gradle/api/Project.java",
  "gradleSource": true
}
// Reasoning: Retrieving the source code for a fundamental Gradle class for high-resolution analysis.
```

### Explore a package via its FQN

Tool: `read_dependency_sources`

```json
{
  "path": "org.gradle.api",
  "projectPath": ":"
}
// Reasoning: Listing the direct symbols and sub-packages of 'org.gradle.api' using index-backed exploration.
```

## Resources

- [Internal Source Research](references/internal_source_research.md) — Combining `gradle_docs` documentation lookup with `gradleSource: true` source searches for authoritative research.
- **Lucene Query Syntax**: Refer to the tool description for `search_dependency_sources` for details on complex queries and escaping.
- **Troubleshooting Targeted Searches**: If `dependency` filter fails, run `inspect_dependencies` to confirm exact coordinates.
