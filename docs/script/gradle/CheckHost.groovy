import org.gradle.internal.os.OperatingSystem;

class CheckHost {

static void checkHostOs() {
   println "CurrentHost : ${OperatingSystem.current()}"
   if (!OperatingSystem.current().isLinux()) {
                throw new RuntimeException()
   }
}

static void checkRequireTools() {
        def UbuntuPackage = [
           wget: 'wget',
           zstd: 'zstd',
        ]

        def FedoraPackage = [
           wget: 'wget',
           zstd: 'zstd',
        ]

        def SourceSpec = [
                Requires: ['wget', 'zstd']
        ]

        def notfound = []
        def ubuntu_packages = []
        def fedora_packages = []
        println "RequireTools: ${SourceSpec.Requires}"
        SourceSpec.Requires.eachWithIndex { cmd,i ->
                def proc = "which ${cmd}".execute()
                proc.waitFor()
                if (proc.exitValue() == 0) {
                        println "Found: ${proc.text}"
                } else {
                        println "Not Found: ${cmd}"
                        notfound << cmd
                        ubuntu_packages << (UbuntuPackage[cmd] ?: "<${cmd}>")
                        fedora_packages << (FedoraPackage[cmd] ?: "<${cmd}>")
                }
        }
        println '----------------'
        if (notfound.size() != 0)  {
                println "Not Found: ${notfound}"
                println "Recommend(ubuntu): sudo apt install ${ubuntu_packages.join(',')}"
                println "Recommend(fedora): sudo dnf install ${fedora_packages.join(',')}"
        }
        if (notfound.size() > 0) {
                throw new RuntimeException("host tools not found: ${notfound}")
        }
}