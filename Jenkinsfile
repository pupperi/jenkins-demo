pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "pupperi/jenkins-demo"
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
                    sh 'docker build -t registry.hub.docker.com/pupperi/jenkins-demo .'
                    sh 'docker run -d -p 8181:8181 registry.hub.docker.com/pupperi/jenkins-demo'
                    sh 'curl localhost:8181'  
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker login -u pupperi -p Love2flY https://registry.hub.docker.com/'
                    sh 'docker tag pupperi/jenkins-demo registry.hub.docker.com/pupperi/jenkins-demo:$BUILD_NUMBER'
                    sh 'docker push registry.hub.docker.com/pupperi/jenkins-demo:$BUILD_NUMBER'
                    sh 'docker tag pupperi/jenkins-demo registry.hub.docker.com/pupperi/jenkins-demo:latest'
                    sh 'docker push registry.hub.docker.com/pupperi/jenkins-demo:latest'
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