pipeline {
    agent any

    environment {
        SONARQUBE = 'SonarQube Server'  // SonarQube Server name from Jenkins configuration
        MAVEN_HOME = '/usr/share/maven'  // Path to Maven home
        NEXUS_REPO = 'releases'  // Nexus repository (e.g., releases, snapshots)
        NEXUS_URL = 'http://52.66.91.138:8081/'  // Nexus repository URL
        DOCKER_IMAGE_NAME = 'retrohit'  // Name of the Docker image
        DOCKER_REGISTRY = 'saicharan6771'  // Docker Hub username
        K8S_NAMESPACE = 'retrohit'  // Kubernetes namespace
        K8S_DEPLOYMENT_NAME = 'retrohit-app'  // Deployment name in Kubernetes
    }

    tools {
        maven 'Maven 3.6.3'  // Specify Maven version from Jenkins tool configuration
        dockerTool 'Docker'  // Specify Docker tool from Jenkins tool configuration
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/retrohit/retrohit.git'  // Checkout the GitHub repo
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube Server') {
                        sh '''
                        mvn clean verify sonar:sonar \
                            -Dsonar.projectKey=inventory-service \
                            -Dsonar.projectName=inventory-service \
                            -Dsonar.host.url=http://3.108.30.160:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }

        stage('Build .jar') {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'  // Skip tests during the build
                }
            }
        }

        stage('Push .jar to Nexus') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                        sh '''
                        mvn deploy:deploy-file \
                            -DgroupId=com.retrohit \
                            -DartifactId=retrohit \
                            -Dversion=1.0-SNAPSHOT \
                            -Dpackaging=jar \
                            -Dfile=target/retrohit-1.0-SNAPSHOT.jar \
                            -DrepositoryId=nexus \
                            -Durl=http://52.66.91.138:8081/repository/releases/ \
                            -DretryFailedDeploymentCount=3 \
                            -DgeneratePom=true \
                            -Dusername=$NEXUS_USER \
                            -Dpassword=$NEXUS_PASS
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    docker build -t $DOCKER_IMAGE_NAME -f Dockerfile .  // Build Docker image
                    '''
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS  // Login to Docker Hub
                        docker tag $DOCKER_IMAGE_NAME $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:latest  // Tag the image
                        docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:latest  // Push to Docker Hub
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    kubectl config use-context kubernetes-admin@kubernetes  // Use the correct Kubernetes context
                    kubectl set image deployment/$K8S_DEPLOYMENT_NAME retrohit=$DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:latest --namespace=$K8S_NAMESPACE  // Update the deployment with the new image
                    kubectl rollout restart deployment/$K8S_DEPLOYMENT_NAME --namespace=$K8S_NAMESPACE  // Restart the deployment to apply changes
                    '''
                }
            }
        }

        stage('Expose to the Outside World (K8s Service)') {
            steps {
                script {
                    sh '''
                    kubectl expose deployment $K8S_DEPLOYMENT_NAME --type=LoadBalancer --name=retrohit-service --namespace=$K8S_NAMESPACE  // Expose the deployment via service
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
