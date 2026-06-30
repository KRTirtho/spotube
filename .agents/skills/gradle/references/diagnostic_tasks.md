# Authoritative Diagnostic Tasks

Gradle provides built-in tasks for deep introspection. Always use `captureTaskOutput` with these for the best experience.

### 1. Project & Task Discovery

- **`projects`**: Lists the sub-projects in the build.
    - `gradle(commandLine=[":projects"], captureTaskOutput=":projects")`
- **`tasks`**: Lists runnable tasks. Use `--all` for a full list (including ungrouped tasks).
    - `gradle(commandLine=[":app:tasks", "--all"], captureTaskOutput=":app:tasks")`
- **`help`**: Displays global or task-specific help.
    - `gradle(commandLine=[":help", "--task", "test"], captureTaskOutput=":help")`

### 2. Property & Environment Auditing

- **`properties`**: Lists all project properties. Use `--property <name>` for surgical extraction.
    - `gradle(commandLine=[":properties", "--property", "version"], captureTaskOutput=":properties")`
- **`javaToolchains`**: Displays detected JVM toolchains and their properties.
    - `gradle(commandLine=[":javaToolchains"], captureTaskOutput=":javaToolchains")`

### 3. Low-Level Dependency & Variant Analysis

- **`dependencyInsight`**: Investigates why a specific dependency version was chosen.
    - `gradle(commandLine=[":app:dependencyInsight", "--dependency", "slf4j-api", "--configuration", "compileClasspath"], captureTaskOutput=":app:dependencyInsight")`
- **`outgoingVariants`**: Displays the variants the project provides to consumers.
    - `gradle(commandLine=[":app:outgoingVariants"], captureTaskOutput=":app:outgoingVariants")`
- **`resolvableConfigurations`**: Displays the configurations available for resolution.
