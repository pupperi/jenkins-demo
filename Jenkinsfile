pipeline {
    agent any
    environment {
        PATH = "/usr/local/go/bin:$PATH"
        DOCKER_IMAGE_NAME = "nginx"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Compiling Program'
            }
        }
        stage('Build Docker Image') {
            when { 
                branch 'master'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.withRun("-d -p 8181:8181") { c ->
                        sh 'curl localhost:8181'
                    }    
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://harbor.workshop.pks101.com', 'harbor') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToPKS') {
            when {
                branch 'master'
            }
            steps {
                milestone(1)
                kubernetesDeploy(
                  kubeconfigId: 'kubeconfig',
                  configs: 'kubernetes.yml',
                  enableConfigSubstitution: true
                ) 
            }
        }
        stage('Get Service IP') {
            when {
                branch 'master'
            }
            steps {
                //milestone(1)
                retry(10) {
                        script {
                            //def ip = sh (script: "kubectl get all", returnStdout: true)
                            def ip = sh (script: "kubectl get svc gocicd --output=jsonpath={'.status.loadBalancer.ingress[].ip'}", returnStdout: true)
                            sh 'sleep 5'
                            echo "IP is ${ip}"
                            echo "URL is http://${ip}:8181"
                            try {
                            } catch (err) {
                             echo: 'caught error: $err'
                            }
                        }
                }
            }
        }
    }
}             
