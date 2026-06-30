# AGENTS

## Repo shape (KMP + modules)
- Gradle multi-module: `:composeApp` (main app), `:plugin_interfaces` (plugin API contracts), `:js_plugin_example` (Zipline JS plugin template).
- `:composeApp` uses custom KMP source sets (`mobileMain`, `androidJvmMain`) with explicit `dependsOn`; Gradle prints "Default Kotlin Hierarchy Template Not Applied Correctly" warning. Treat as known/expected.

## Real app entrypoints
- Desktop/JVM: `composeApp/src/jvmMain/kotlin/dev/krtirtho/spotube/main.kt` (`mainClass = dev.krtirtho.spotube.MainKt`).
- Android: `composeApp/src/androidMain/kotlin/dev/krtirtho/spotube/MainActivity.kt`.
- iOS bridge: `composeApp/src/iosMain/kotlin/dev/krtirtho/spotube/MainViewController.kt` and `iosApp/iosApp/ContentView.swift`.

## High-value commands
- Use Gradle wrapper (`./gradlew` or `./gradlew.bat`) only.
- Run desktop: `:composeApp:run`
- Build Android debug: `:composeApp:assembleDebug`
- Module checks: `:composeApp:check`, `:plugin_interfaces:check`, `:js_plugin_example:check`
- Focused tests: `:composeApp:jvmTest`, `:composeApp:iosSimulatorArm64Test`, `:plugin_interfaces:jvmTest`, `:plugin_interfaces:jsTest`, `:js_plugin_example:jsTest`
- No lint/typecheck/formatter tasks are configured; `:composeApp:check` is the only aggregated check.

## Dependencies
- `gradle/libs.versions.toml` is the single source of truth for all version pins and library declarations.
- Kotlin: `2.3.0`, JVM target: `11` (compile/target compatibility in both `composeApp/build.gradle.kts` and `plugin_interfaces/build.gradle.kts`).

## Codegen and plugin packaging
- OpenAPI client generated from `composeApp/specs/listenbrainz-openapi.yaml` via KMPGen tasks (`kmpgenPrepare`, `kmpgenGenerateAll`) in `:composeApp`.
- JS plugin bundles: `:js_plugin_example:packageDevelopmentPlugin` and `:js_plugin_example:packageProductionPlugin`. Output is `.smplug` files in `js_plugin_example/build/distributions/`.
- Zipline plugin entrypoint: `mainFunction = "dev.krtirtho.js_plugin_example.main"` in `js_plugin_example/build.gradle.kts`. Plugin metadata from `js_plugin_example/plugin.json`.

## Plugin architecture
- `plugin_interfaces` exports `zipline.core` and `semver` as API. `composeApp` depends on it for the plugin system.
- `plugin_interfaces` also has a JS target (`browser()`), used by the plugin system.

## Desktop JVM specifics
- JavaFX is required; `--add-opens` flags in `compose.desktop.application.jvmArgs` must be preserved: `javafx.graphics/javafx.scene`, `javafx.graphics/com.sun.javafx.sg.prism`, `javafx.graphics/com.sun.javafx.scene`, `javafx.web/com.sun.webkit`, `javafx.media/com.sun.media.jfxmedia`, `javafx.media/com.sun.media.jfxmedia.events`.
- JavaFX dependencies are loaded from OpenJFX with platform classifiers (win/mac/linux) resolved at configuration time via `System.getProperty("os.name")`.

## Tooling
- Gradle config cache enabled (`gradle.properties`); prefer module-scoped tasks.
- Gradle daemon JVM pinned to JetBrains JDK 21 via `gradle/gradle-daemon-jvm.properties`.
- Gradle 8.14.3 (from `gradle/wrapper/gradle-wrapper.properties`).
- Foojay toolchain resolver in use (`plugins { id("org.gradle.toolchains.foojay-resolver-convention") }`).

## Current testing reality
- No committed `*Test*.kt` files; test tasks may run zero tests unless new tests are added.