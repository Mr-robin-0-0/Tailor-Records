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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureNamespace = Action<Project> {
        if (plugins.hasPlugin("com.android.library") || plugins.hasPlugin("com.android.application")) {
            val android = extensions.findByType<com.android.build.gradle.BaseExtension>()
            if (android != null && android.namespace.isNullOrEmpty()) {
                android.namespace = project.group.toString().takeIf { it.isNotEmpty() } ?: "com.example.${project.name.replace("-", "_")}"
            }
        }
    }

    if (state.executed) {
        configureNamespace.execute(this)
    } else {
        afterEvaluate { configureNamespace.execute(this) }
    }
}

subprojects {
    if (project.name != "app") {
        afterEvaluate {
            val android = extensions.findByType<com.android.build.gradle.BaseExtension>()
            android?.compileSdkVersion(35)
        }
    }
}

