# Common Gradle Build Patterns & Conventions

A collection of idiomatic patterns for common Gradle build scenarios, including multi-project setups, convention plugins, and task registration.

## 1. Multi-Project Build Structure

Standard project structure with a root project and multiple subprojects.

### Directory Structure

```
root/
├── build.gradle.kts
├── settings.gradle.kts
├── libs.versions.toml
├── app/
│   └── build.gradle.kts
├── core/
│   └── build.gradle.kts
└── build-logic/
    ├── build.gradle.kts
    └── settings.gradle.kts
```

### `settings.gradle.kts`

```kotlin
pluginManagement {
    includeBuild("build-logic")
}

rootProject.name = "my-project"
include(":app", ":core")

dependencyResolutionManagement {
    versionCatalogs {
        create("libs") {
            from(files("gradle/libs.versions.toml"))
        }
    }
    repositories {
        mavenCentral()
    }
}
```

## 2. Convention Plugins (The `build-logic` Pattern)

Move common project configuration logic into separate plugins to reduce duplication in `build.gradle.kts` files.

### `build-logic/build.gradle.kts`

```kotlin
plugins {
    `kotlin-dsl`
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
}
```

### `build-logic/src/main/kotlin/my-convention.gradle.kts`

```kotlin
plugins {
    kotlin("jvm")
}

repositories {
    mavenCentral()
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinJvmCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}
```

### Usage in Subprojects

```kotlin
plugins {
    id("my-convention")
}
```

## 3. Registering Custom Tasks

Use lazy task registration and configure properties with the `Property` and `Provider` APIs.

```kotlin
abstract class MyCustomTask : DefaultTask() {
    @get:Input
    abstract val message: Property<String>

    @TaskAction
    fun action() {
        println("Message: ${message.get()}")
    }
}

tasks.register<MyCustomTask>("myTask") {
    message.set("Hello from custom task!")
}
```

## 4. Configuring Standard Plugins

### Java/Kotlin Library

```kotlin
plugins {
    `java-library`
    kotlin("jvm")
}

dependencies {
    api("com.example:some-api:1.0")
    implementation("com.example:some-impl:1.0")
    testImplementation(kotlin("test"))
}
```

### Application Plugin

```kotlin
plugins {
    application
}

application {
    mainClass.set("com.example.Main")
}
```

## Resources

- [Multi-project builds](https://docs.gradle.org/current/userguide/multi_project_builds.html)
- [Developing Custom Gradle Plugins](https://docs.gradle.org/current/userguide/custom_plugins.html)
- [Authoring maintainable builds](https://docs.gradle.org/current/userguide/authoring_maintainable_builds.html)
