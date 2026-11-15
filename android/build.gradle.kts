import com.android.build.gradle.LibraryExtension

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
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    plugins.withId("com.android.library") {
        if (project.name == "isar_flutter_libs") {
            extensions.configure<LibraryExtension> {
                if (namespace == null) {
                    namespace = "dev.isar.isar_flutter_libs"
                }
            }
        }

    }
}

// Certains plugins (isar_flutter_libs, printing...) sont compilés en API 30,
// mais leurs dépendances AndroidX utilisent android:attr/lStar (API 31) : sans
// ça, le build release échoue sur verifyReleaseResources (le debug ne vérifie
// pas ces ressources). On relève l'API une fois le build.gradle du module lu
// (sinon il écraserait notre valeur) et avant que le plugin Android ne la fige,
// d'où l'enregistrement ici, depuis le script racine.
subprojects {
    if (!state.executed) {
        afterEvaluate {
            if (plugins.hasPlugin("com.android.library")) {
                extensions.configure<LibraryExtension> {
                    if ((compileSdk ?: 0) < 36) compileSdk = 36
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
