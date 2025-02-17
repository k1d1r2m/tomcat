pipeline {  
    agent any  

	environment {
		MAVEN_HOME = tool 'maven3.9.0' //maven tool installed in jenkins level
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
        }
}
