plugins {
    id("com.android.application") version "8.6.0" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // â¬‡ï¸ Ð­Ð½Ð¸Ð¹Ð³ Ð½ÑÐ¼Ð½Ñ â€” path_provider Ð±Ð¾Ð»Ð¾Ð½ Ð±ÑƒÑÐ°Ð´ plugin-ÑƒÑƒÐ´Ñ‹Ð½ compileSdk Ð°Ð»Ð´Ð°Ð°Ð³ Ð·Ð°ÑÐ½Ð°
    afterEvaluate {
        extensions.findByType(com.android.build.gradle.BaseExtension::class.java)?.apply {
            compileSdkVersion(34)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}