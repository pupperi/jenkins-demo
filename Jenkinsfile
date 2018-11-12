pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "pupperi/nginx-demo"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Compiling Program'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToPKS') {
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
            steps {
                retry(10) {
                        script {
                            def ip = sh (script: "kubectl get service nginx --output=jsonpath={'.status.loadBalancer.ingress[].hostname'}", returnStdout: true)
                            sh 'sleep 30'
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
