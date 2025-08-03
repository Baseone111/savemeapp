import org.gradle.api.Project
import com.android.build.gradle.LibraryPlugin
import com.android.build.gradle.AppPlugin
import com.android.build.gradle.LibraryExtension
import com.android.build.gradle.AppExtension

// This block defines configurations for the build scripts themselves.
buildscript {
    val kotlin_version = "1.9.0"

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0") // IMPORTANT: Use your actual AGP version
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

// Define extra properties directly on the root project's 'extra' extension.
rootProject.extra.set("minSdkVersion", 21)
rootProject.extra.set("compileSdkVersion", 35)
rootProject.extra.set("targetSdkVersion", 35)
rootProject.extra.set("kotlin_version", "1.9.0")


// Refactored: Use subprojects to configure Android extension directly
allprojects { // Keep this as allprojects
    repositories {
        google()
        mavenCentral()
    }

    val rootMinSdk = rootProject.extra["minSdkVersion"] as Int
    val rootCompileSdk = rootProject.extra["compileSdkVersion"] as Int
    val rootTargetSdk = rootProject.extra["targetSdkVersion"] as Int

    // Configure Android Library projects (like Flutter plugins)
    plugins.withType<LibraryPlugin> {
        project.extensions.configure(LibraryExtension::class) {
            compileSdkVersion(rootCompileSdk)
            defaultConfig {
                minSdkVersion(rootMinSdk)
                targetSdkVersion(rootTargetSdk)
            }
        }
    }

    // Configure Android Application projects (your main app module)
    plugins.withType<AppPlugin> {
        project.extensions.configure(AppExtension::class) {
            compileSdkVersion(rootCompileSdk)
            defaultConfig {
                minSdkVersion(rootMinSdk)
                targetSdkVersion(rootTargetSdk)
            }
        }
    }
}

// Your existing configurations for build directories and clean task:
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// The subprojects block for build directory configuration should be separate
// from the one configuring Android SDK versions.
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}