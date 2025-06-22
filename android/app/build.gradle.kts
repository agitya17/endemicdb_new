plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.endemikdb_new"
    compileSdk = flutter.compileSdkVersion

    ndkVersion = "27.0.12077973" // Ensure NDK version is correct

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.endemikdb_new"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Enable multidex support if needed (for apps with >65K methods)
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so flutter run --release works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packagingOptions {
        resources.excludes += "/META-INF/*.RSA"
        resources.excludes += "/META-INF/*.SF"
        resources.excludes += "/META-INF/*.MF"
    }

    lintOptions {
        disable.add("InvalidPackage") // Disable specific lint warnings if necessary
    }
}

flutter {
    source = "../.."
}