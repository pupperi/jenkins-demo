pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "pupperi/demo/jenkins-demo"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Compiling Program'
            }
        }
        stage('Build Docker Image 123') {
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
                    docker.withRegistry('pupperi/demo', 'pupperi') {
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
                            def ip = sh (script: "kubectl get svc golang --output=jsonpath={'.status.loadBalancer.ingress[].hostname'}", returnStdout: true)
                            sh 'sleep 300'
                            echo "IP is ${ip}"
                            echo "URL is http://${ip}"
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
