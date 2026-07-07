# Prevent ProGuard from deleting or obfuscating sun.misc.Unsafe
-keep class sun.misc.Unsafe { *; }
-dontwarn sun.misc.Unsafe

## Rules for NewPipeExtractor
-keep class org.mozilla.javascript.** { *; }
-keep class org.mozilla.classfile.ClassFileWriter
-dontwarn org.mozilla.javascript.tools.**

# 1. Keep all NewPipeExtractor classes, methods, and fields intact
-keep class org.schabi.newpipe.extractor.** { *; }

# 2. CRITICAL: Prevent ProGuard from stripping the 'enum' flag from NewPipe enums
# This specifically fixes the "MediaCapability not an enum" ClassCastException
-keepclassmembers enum org.schabi.newpipe.extractor.** {
    public static **[] values();
    public static ** valueOf(java.lang.String);
    *;
}

# 3. Keep ServiceLoader / SPI implementations used by NewPipe to discover services
-keep class * implements org.schabi.newpipe.extractor.Extractor { *; }
-keep class * implements org.schabi.newpipe.extractor.downloader.Downloader { *; }

# JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**

# Animal Sniffer compileOnly dependency to ensure APIs are compatible with older versions of Java.
-dontwarn org.codehaus.mojo.animal_sniffer.*

# OkHttp platform used only on JVM and when Conscrypt and other security providers are available.
# May be used with robolectric or deliberate use of Bouncy Castle on Android
-dontwarn okhttp3.internal.platform.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-keepattributes Signature
-keepattributes Annotation
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

-dontwarn kotlin.Deprecated$Container
-dontwarn com.google.re2j.**

-dontwarn java.awt.*
-keep class com.sun.jna.* { *; }
-keep class * extends com.sun.jna.* { *; }
-keepclassmembers class * extends com.sun.jna.* { public *; }

# Most of volatile fields are updated with AtomicFU and should not be mangled/removed
-keepclassmembers class io.ktor.** {
    volatile <fields>;
}

-keepclassmembernames class io.ktor.** {
    volatile <fields>;
}

# client engines are loaded using ServiceLoader so we need to keep them
-keep class io.ktor.client.engine.** implements io.ktor.client.HttpClientEngineContainer

-keep class uk.co.caprica.** { *; }

# Prevent ProGuard from renaming, stripping, or optimizing Jetpack Navigation 3 UI structures
-keep class androidx.navigation3.** { *; }
-keep interface androidx.navigation3.** { *; }
-dontwarn androidx.navigation3.**

# Keep related navigation event artifacts intact
-keep class androidx.navigationevent.** { *; }
-dontwarn androidx.navigationevent.**

-keep class dev.whyoleg.cryptography.** { *; }
-keep interface dev.whyoleg.cryptography.** { *; }

-keep class okio.** { *; }
-keep interface okio.** { *; }
-keepclassmembers class okio.** { *; }

-keep class app.cash.zipline.** { *; }
-keep interface app.cash.zipline.** { *; }
-keepclassmembers class app.cash.zipline.** { *; }
-dontwarn app.cash.zipline.**

# Keep all Ktor serialization provider metadata files intact
-keep class io.ktor.serialization.** { *; }
-keep interface io.ktor.serialization.** { *; }

# Tell ProGuard to explicitly keep the underlying service registration descriptors
-keepclassmembers class * implements io.ktor.serialization.kotlinx.KotlinxSerializationExtensionProvider { *; }

# Keep all core Coil packages intact
#-keep class coil3.** { *; }
#-keep interface coil3.** { *; }
#-dontwarn coil3.**
#
## Keep platform-specific image decoders (Skia/Skiko rendering targets for desktop)
#-keep class coil3.decode.** { *; }
#-keep class coil3.request.** { *; }
#
## Coil uses Ktor or OkHttp internally for fetching images over the network
## Ensure its network fetcher factory singletons aren't stripped
#-keep class * implements coil3.fetch.Fetcher$Factory { *; }
#-keep class * implements coil3.decode.Decoder$Factory { *; }
#
## Keep SVG or extra dynamic graphic components if you use them
#-keep class coil3.svg.** { *; }
-keep class coil3.util.DecoderServiceLoaderTarget { *; }
-keep class coil3.util.FetcherServiceLoaderTarget { *; }
-keep class coil3.util.ServiceLoaderComponentRegistry { *; }
-keep class * implements coil3.util.DecoderServiceLoaderTarget { *; }
-keep class * implements coil3.util.FetcherServiceLoaderTarget { *; }

# AndroidX Car App Library
-keep class androidx.car.app.** { *; }
-keep interface androidx.car.app.** { *; }
-dontwarn androidx.car.app.**