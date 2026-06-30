# Official Gradle Documentation Research

Guidance on using the `gradle_docs` tool for authoritative documentation lookup, including the User Guide, DSL Reference, Release Notes, samples, and API reference.

## Searching the User Guide

```json
{
  "query": "tag:userguide working with files",
  "projectRoot": "/absolute/path/to/project"
}
```

## Navigating the DSL Reference

```json
{
  "path": "dsl/org.gradle.api.Project.html",
  "projectRoot": "/absolute/path/to/project"
}
```

## Searching for Samples

Official code samples are indexed with the `tag:samples` metadata:

```json
{
  "query": "tag:samples toolchains",
  "projectRoot": "/absolute/path/to/project"
}
```

## Searching Javadocs

Technical API documentation is indexed with the `tag:javadoc` metadata:

```json
{
  "query": "tag:javadoc Project",
  "projectRoot": "/absolute/path/to/project"
}
```

## Best Practices

### Getting an Index of Best Practices

First, explore the `userguide/` directory to identify the correct files:

```json
{
  "path": "userguide/",
  "projectRoot": "/absolute/path/to/project"
}
```

This lists the contents of the `userguide` directory. Look for files starting with `best_practices` (e.g., `best_practices.md`, `best_practices_dependency_management.md`). Once identified, read the main index:

```json
{
  "path": "userguide/best_practices.md",
  "projectRoot": "/absolute/path/to/project"
}
```

### Searching for Best Practices

```json
{
  "query": "tag:best-practices dependency management",
  "projectRoot": "/absolute/path/to/project"
}
```

### Searching for Specific Guidance

```json
{
  "query": "tag:userguide performance best practices",
  "projectRoot": "/absolute/path/to/project"
}
```

## Exploring the Documentation Tree

Use `gradle_docs` with `path="."` to explore the root documentation tree:

```json
{
  "path": ".",
  "projectRoot": "/absolute/path/to/project"
}
```

## External Resources

- [Official Gradle Best Practices](https://docs.gradle.org/current/userguide/best_practices.html)
- [Gradle Performance Guide](https://docs.gradle.org/current/userguide/performance.html)
- [Kotlin DSL Primer](https://docs.gradle.org/current/userguide/kotlin_dsl.html)
