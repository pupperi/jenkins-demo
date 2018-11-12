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
        stage('DeployToPKS') {
            steps {
                script{
                   sh 'kubectl --kubeconfig /var/root/.kube/config create -f kubernetes.yml'
               } 
            }
        }
        stage('Get Service IP') {
            steps {
                script {
                    //def ip = sh (script: "kubectl get all", returnStdout: true)
                            def ip = sh (script: "kubectl --kubeconfig /var/root/.kube/config get service nginx --output=jsonpath={'.status.loadBalancer.ingress[].hostname'}", returnStdout: true)
                            sh 'sleep 10'
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
