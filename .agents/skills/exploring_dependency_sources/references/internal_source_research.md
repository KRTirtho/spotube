# Gradle Internal Source Research

Guidance for researching Gradle Build Tool's internal implementation and third-party plugin source code using `search_dependency_sources` and `read_dependency_sources`.

## Searching the Gradle Engine

Use `gradleSource = true` and select the appropriate `searchType`:

### DECLARATION: Finding Class/Interface Definitions

```json
{
  "query": "DefaultProject",
  "searchType": "DECLARATION",
  "gradleSource": true
}
```

Search by simple name, FQN, or partial package paths. All declaration searches are **case-sensitive**.

### DECLARATION with FQN Glob Wildcards

```json
{
  "query": "fqn:org.gradle.*.Project",
  "searchType": "DECLARATION",
  "gradleSource": true
}
```

`*` matches one segment, `**` matches multiple. Example: `fqn:org.**.AbstractTask`.

### Regex on FQN for Internal APIs

```json
{
  "query": "fqn:/.*\\.internal\\..*/",
  "searchType": "DECLARATION",
  "gradleSource": true
}
```

### FULL_TEXT: Searching Implementation Patterns

```json
{
  "query": "configurationCache",
  "gradleSource": true
}
```

**Case-insensitive** text search. Escape Lucene special characters (`:`, `=`, `+`, `-`, `*`, `/`) with backslash.

### GLOB: Finding Internal Resource Files

```json
{
  "query": "**/plugin.properties",
  "searchType": "GLOB",
  "gradleSource": true
}
```

**Case-insensitive** file name search.

## Reading Implementation Details

Once a class is identified via search, read its source:

```json
{
  "path": "org/gradle/api/Project.java",
  "gradleSource": true
}
```

For large files, use `pagination`:

```json
{
  "path": "org/gradle/api/Project.java",
  "gradleSource": true,
  "pagination": {
    "offset": 0,
    "limit": 100
  }
}
```

## Researching Plugin Source Code

Plugin (buildscript) dependencies are excluded by default. Use `sourceSetPath=":buildscript"` to include them:

### Searching Plugin Classes

```json
{
  "query": "KotlinPlugin",
  "searchType": "DECLARATION",
  "sourceSetPath": ":buildscript"
}
```

### Reading Plugin Source

```json
{
  "path": "org.jetbrains.kotlin/kotlin-gradle-plugin/org/jetbrains/kotlin/gradle/plugin/KotlinPlugin.kt",
  "sourceSetPath": ":buildscript"
}
```

## Tracing Symbols Across Scopes

When encountering an unknown Gradle API or plugin class:

1. Search with `gradleSource: true` for engine classes.
2. Search with `sourceSetPath=":buildscript"` for plugin classes.
3. Read the implementation with `read_dependency_sources`.
4. Cross-reference with official documentation via `gradle_docs` (see `gradle` skill).

## Troubleshooting

- **Source Not Found**: Some Gradle internal modules may not be fully indexed. Try a broader `FULL_TEXT` search or browse the directory structure via `read_dependency_sources` with `gradleSource: true`.
- **Plugin Not Found**: Ensure the plugin is resolved in the buildscript classpath. Use `inspect_dependencies(sourceSetPath=":buildscript")` to verify.
- **Index Error**: Use `fresh: true` if searching after dependency changes.
