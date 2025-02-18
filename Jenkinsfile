pipeline {  
    agent any  

	environment {
		MAVEN_HOME = tool 'maven3.9.0' //maven tool installed in jenkins level
		IMAGE_NAME = 'veedhi1995/onlinestore-java-tomcat'
		GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
		IMAGE_TAG  =  '${IMAGE_NAME}:${env.GIT_COMMIT}'

	}
        stages {  
       	    stage("code checkout") {  
           	    steps {  
              	      git branch: 'veedhi', url: 'https://github.com/veedhi25/onlinebookstore.git'  
              	    }  
         	    }
			stage("maven build") {
			  steps {	
			    script{
                  sh "${MAVEN_HOME}/bin/mvn clean package"
			     }
			  }  
			}  
			stage("image build") {
				steps{
					script{
						sh 'docker build -t ${IMAGE_TAG} .'
						echo "image is build succesfully"
						sh 'docker images'

					}
				}

			} 			
        }
}
