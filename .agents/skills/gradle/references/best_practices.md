# Gradle Build Logic Best Practices

**IMPORTANT**: This document provides a high-level snapshot of common best practices. However, Gradle is a rapidly evolving tool. **You MUST use the `gradle_docs` tool to retrieve the most up-to-date and comprehensive best practices
directly from the official documentation.**

## 1. Authoritative Research Workflow

Before implementing significant build logic, always perform a search for the latest recommendations using scoped queries and project context.

### Example: Getting an Index of Best Practices

To find the authoritative index of best practices within the User Guide, first explore the `userguide/` directory to identify the correct files.

Tool: `gradle_docs`

```json
{
  "path": "userguide/",
  "projectRoot": "/absolute/path/to/project"
}
```

**Reasoning**: This call lists the contents of the `userguide` directory. Look for files starting with `best_practices` (e.g., `best_practices.md`, `best_practices_dependency_management.md`). Once identified, read the main index:

Tool: `gradle_docs`

```json
{
  "path": "userguide/best_practices.md",
  "projectRoot": "/absolute/path/to/project"
}
```

### Example: Searching for Best Practices

Tool: `gradle_docs`

```json
{
  "query": "tag:best-practices dependency management",
  "projectRoot": "/absolute/path/to/project"
}
```

**Reasoning**: Using the authoritative `best-practices` tag ensures the returned content is filtered for high-signal architectural recommendations.

### Example: Searching for Specific Guidance

Tool: `gradle_docs`

```json
{
  "query": "tag:userguide performance best practices",
  "projectRoot": "/absolute/path/to/project"
}
```

---

## 2. Engine-Level Discovery (The "Source of Truth")

To understand the core architectural principles behind best practices, you can explore Gradle's own source documentation.

### Example: Listing Core Concepts and Documentation

Use `gradle_docs` with `path="."` to explore the root documentation tree.

Tool: `gradle_docs`

```json
{
  "path": ".",
  "projectRoot": "/absolute/path/to/project"
}
```

---

## 3. High-Level Snapshot (Current Guidelines)

The following sections summarize established idiomatic patterns. Use these as a starting point, but verify against the official docs.

### Kotlin DSL Idiomatic Patterns

- **Use Type-Safe Accessors**: Prefer `tasks.test { ... }` or `tasks.named<Test>("test") { ... }` over `tasks.getByName("test")`.
- **Prefer `register` over `create` (Lazy APIs)**: Use `tasks.register<MyTask>("myTask")` to avoid eager task configuration.
- **Use Lazy Properties**: Employ the `Property<T>` and `Provider<T>` APIs for late binding and better configuration cache compatibility.

### Performance & Configuration Cache

- **Enable Configuration Cache**: Ensure build logic avoids accessing the `Project` object inside task actions.
- **Use Specific Annotations**: Properly label task properties with `@Input`, `@OutputFiles`, `@Internal`, etc.
- **Minimize Logic in Build Scripts**: Move complex logic into convention plugins or `buildSrc`.

### Dependency Management

- **Use Version Catalogs**: Centralize dependencies in `gradle/libs.versions.toml`.
- **Avoid `allprojects` and `subprojects`**: These blocks create tight coupling; use convention plugins and apply them selectively instead.

### Project Integrity

- **Reproducible Builds**: Use fixed versions and commit the Gradle wrapper.
- **Surgical Updates**: Only update what is necessary and verify with `check`.

## Resources (Official Source of Truth)

- [Official Gradle Best Practices](https://docs.gradle.org/current/userguide/best_practices.html)
- [Gradle Performance Guide](https://docs.gradle.org/current/userguide/performance.html)
- [Kotlin DSL Primer](https://docs.gradle.org/current/userguide/kotlin_dsl.html)
