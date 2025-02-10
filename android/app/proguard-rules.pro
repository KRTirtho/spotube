-keep class androidx.lifecycle.DefaultLifecycleObserver

-keepnames class kotlinx.serialization.** { *; }
-keepnames class oss.krtirtho.spotube.glance.models.** { *; }
-keep @kotlinx.serialization.Serializable class *
-keepclassmembers class ** {
    @kotlinx.serialization.* <fields>;
}

## We don't need beans
-dontwarn java.beans.BeanDescriptor
-dontwarn java.beans.BeanInfo
-dontwarn java.beans.IntrospectionException
-dontwarn java.beans.Introspector
-dontwarn java.beans.PropertyDescriptor

## Rules for NewPipeExtractor
-keep class org.schabi.newpipe.extractor.timeago.patterns.** { *; }
-keep class org.mozilla.javascript.** { *; }
-keep class org.mozilla.classfile.ClassFileWriter
-dontwarn org.mozilla.javascript.tools.**