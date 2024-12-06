plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.google.gms.google.services)
}

android {
    namespace = "com.example.giziku"
    compileSdk = 34

    buildFeatures {
        viewBinding = true
    }

    defaultConfig {
        applicationId = "com.example.giziku"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}

dependencies {
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)
    implementation(libs.circleimageview)

    implementation(libs.mpandroidchart)
    implementation(libs.play.services.tasks)
    implementation ("com.google.firebase:firebase-auth:21.0.1") // Check for the latest version
    implementation ("androidx.activity:activity:1.6.0")
    implementation(libs.firebase.firestore)
    implementation ("com.google.firebase:firebase-firestore:24.0.1") // Check for the latest version
    implementation("com.squareup.picasso:picasso:2.71828")
    implementation("com.google.guava:guava:31.0.1-android")
    implementation("com.google.ai.client.generativeai:generativeai:0.7.0")
    implementation("com.google.android.material:material:1.2.0")
    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)
}