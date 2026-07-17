allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = File("C:/flutter_build/mi_app_build")
subprojects {
    project.buildDir = File("C:/flutter_build/mi_app_build/${project.name}")
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
