pipeline {  
    agent any  

    environment {
        MAVEN_HOME = tool 'maven3.9.0' // Maven tool installed in Jenkins
        IMAGE_NAME = 'veedhi1995/onlinestore-java-tomcat'
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
         stage("deploy to hub") {
              steps {
                  withCredentials([usernameColonPassword(credentialsId: 'hubcred', usernamevariable: 'USERNAME',Passwordvariable: 
          'PASSWORD')]) { 
                      sh'echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin'}
                         echo "login succesfully"
              }
         }
                                      
                      
    }
    
}
