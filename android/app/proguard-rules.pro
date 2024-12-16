-keep class androidx.lifecycle.DefaultLifecycleObserver

-keepnames class kotlinx.serialization.** { *; }
-keepnames class oss.krtirtho.spotube.glance.models.** { *; }
-keep @kotlinx.serialization.Serializable class *
-keepclassmembers class ** {
    @kotlinx.serialization.* <fields>;
}
