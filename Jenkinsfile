pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "harbor.workshop.pks101.com/library/nginx"
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
                    app.withRun("-d -p 80:8181") { c ->
                        //sh 'curl localhost:80'
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
                    docker.withRegistry('https://harbor.workshop.pks101.com/', 'harbor') {
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
                            def ip = sh (script: "kubectl get svc nginx --output=jsonpath={'.status.loadBalancer.ingress[].ip'}", returnStdout: true)
                            sh 'sleep 5'
                            echo "IP is ${ip}"
                            echo "URL is http://${ip}:80"
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
