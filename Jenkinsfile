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
                    sh 'docker build -t registry.hub.docker.com/pupperi/nginx-demo .'
                    sh 'docker run -d -p 8181:8181 registry.hub.docker.com/pupperi/nginx-demo'  
                    //sh 'docker stop $(docker ps -q)'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker login -u pupperi -p Love2flY https://registry.hub.docker.com/'
                    sh 'docker tag registry.hub.docker.com/pupperi/nginx-demo registry.hub.docker.com/pupperi/nginx-demo:$BUILD_NUMBER'
                    sh 'docker push registry.hub.docker.com/pupperi/nginx-demo:$BUILD_NUMBER'
		    sh 'docker tag registry.hub.docker.com/pupperi/nginx-demo registry.hub.docker.com/pupperi/nginx-demo:latest'
		    sh 'docker push registry.hub.docker.com/pupperi/nginx-demo:latest'
                }
            }
        }
        stage('DeployToPKSvSphere') {
            steps {
                script{
                   echo ' Deploying to vSphere' 
                   sh 'kubectl --kubeconfig /root/.kube/config apply -f kubernetes.yml'
               } 
            }
        }
        stage('DeployToPKSAWS') {
            steps {
                script{
                    echo 'Deploying to AWS'
                   //sh 'kubectl --kubeconfig /root/.kube/config apply -f kubernetes.yml'
               } 
            }
        }
    }
}             
