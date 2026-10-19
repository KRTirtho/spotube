// Build logic for the Linux AppImage bundle (see DownloadLinuxGtkBundleTask). Lives in buildSrc so the IDE
// resolves it; an `apply(from = ...)` script plugin gets no Kotlin classpath in Android Studio.
plugins {
    `kotlin-dsl`
}

repositories {
    mavenCentral()
}
