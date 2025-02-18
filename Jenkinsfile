pipeline {  
    agent any  

    environment {
        MAVEN_HOME = tool 'maven3.9.0' // Maven tool installed in Jenkins
        IMAGE_NAME = 'veedhi1995/onlinestore-java-tomcat'
		KUBECONFIG = credentials('yamlcred')
    }

    stages {  
        stage("Code Checkout") {  
            steps {  
                git branch: 'veedhi', url: 'https://github.com/veedhi25/onlinebookstore.git'  
            }  
        }

        stage("Maven Build") {
            steps {    
                script {
                    sh "${MAVEN_HOME}/bin/mvn clean package"
                }
            }  
        }  

        stage("Image Build") {
            steps {
                script {
                    // Fetch Git commit hash dynamically
                    def GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()

                    // Construct the Docker image tag dynamically
                    def IMAGE_TAG = "${IMAGE_NAME}:${GIT_COMMIT}"

                    echo "Building Docker image: ${IMAGE_TAG}"

                    sh "docker build -t ${IMAGE_TAG} ."
                    echo "Image built successfully"

                    sh "docker images"
                }
            }
        } 

        stage("Deploy to Docker Hub") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'hubcred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) { 
                    sh "echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin"
                    echo "Login successful"

                    script {
                        def GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                        def IMAGE_TAG = "${IMAGE_NAME}:${GIT_COMMIT}"

                        echo "Pushing Docker image: ${IMAGE_TAG}"
                        sh "docker push ${IMAGE_TAG}"
                        echo "Image pushed successfully"
                    }
                }
            }
        }
		stage("deploy to k8s") {
			stages{
				sh  'kubectl config user-context kubernetes-admin@kubernetes'
				sh  'kubectl config current-context'
				sh  "kubectl set image deployment/onlinebookstore  onlinebookstore=${IMAGE_TAG} -n onlinebookstore-ns"

			}
		}
    }
}
