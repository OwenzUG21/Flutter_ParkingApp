import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.project8"
    compileSdk = 36

    ndkVersion = "29.0.13846066"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }

    // Build performance optimizations
    buildFeatures {
        buildConfig = true
    }

    // Disable unnecessary features for faster builds
    buildFeatures {
        aidl = false
        renderScript = false
        resValues = false
        shaders = false
    }

    

    packagingOptions {
        resources {
            excludes += setOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt"
            )
        }
    }
    
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.project8"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion  // Required for OneSignal
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // OneSignal configuration
        manifestPlaceholders["onesignal_app_id"] = "c50bd364-9db8-4cc6-a060-d71cd9c55c82"
        manifestPlaceholders["onesignal_google_project_number"] = "501404852685"
    }

    buildTypes {
        debug {
            // Disable all optimizations for debug builds
            isMinifyEnabled = false
            isShrinkResources = false
            isDebuggable = true
            // Skip R8 optimization completely
            proguardFiles.clear()
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false  // Disable for faster builds
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    
    // Google Play Services for push notifications
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
    implementation("com.google.firebase:firebase-messaging")
    
    // Android 12+ splash screen for instant launch
    implementation("androidx.core:core-splashscreen:1.0.1")
}
