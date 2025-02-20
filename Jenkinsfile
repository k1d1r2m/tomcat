pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'maven3.9.0' // Maven tool installed in Jenkins
        IMAGE_NAME = 'veedhi1995/onlinestore-java-tomcat'
        KUBECONFIG = credentials('yamlcred') // Kubernetes config stored in Jenkins
    }

    stages {
        stage("git checkout") {
            steps {
                git branch: 'veedhi', url: 'https://github.com/veedhi25/onlinebookstore.git'
            }
        }

        stage("Build") {
            steps {
                script {
                    sh "${MAVEN_HOME}/bin/mvn clean package"
                }
            }
        }

        stage("Image Build & Push") {
            steps {
                script {
                    // Get latest Git commit hash
                    def GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def IMAGE_TAG = "${IMAGE_NAME}:${GIT_COMMIT}"

                    echo "Building Docker image: ${IMAGE_TAG}"

                    sh "docker build -t ${IMAGE_TAG} ."
                    echo "Image built successfully"

                    withCredentials([usernamePassword(credentialsId: 'hubcred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin"
                        echo "Login successful"

                        echo "Pushing Docker image: ${IMAGE_TAG}"
                        sh "docker push ${IMAGE_TAG}"
                        echo "Image pushed successfully"
                    }

                    // Store IMAGE_TAG for next stages
                    env.BUILT_IMAGE_TAG = IMAGE_TAG
                }
            }
        }

        stage("Deploy to Kubernetes") {
            steps {
                script {
                    // Ensure the environment variable is accessible
                    def IMAGE_TAG = env.BUILT_IMAGE_TAG

                    echo "Deploying image: ${IMAGE_TAG} to Kubernetes"

                    // Set Kubernetes context
                    sh "kubectl config use-context kubernetes-admin@kubernetes"
                    sh "kubectl config current-context"

                    // Update Kubernetes deployment with the specific image tag
                    sh "kubectl set image deployment/onlinebookstore onlinebookstore=${IMAGE_TAG} -n onlinebookstore-ns"

                    // Restart the deployment to apply changes
                    sh "kubectl rollout restart deployment onlinebookstore -n onlinebookstore-ns"
                    echo "Deployment updated successfully with image ${IMAGE_TAG}"
                }
            }
        }
    }
}
