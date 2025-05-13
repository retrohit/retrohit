pipeline {
    agent any

    environment {
        SONARQUBE = 'SonarQube Server'
        MAVEN_HOME = '/usr/share/maven'
        NEXUS_REPO = 'snapshots'
        NEXUS_URL = 'http://52.66.91.138:8081/'
        DOCKER_IMAGE_NAME = 'retrohit'
        DOCKER_REGISTRY = 'saicharan6771'
        K8S_NAMESPACE = 'retrohit'
        K8S_DEPLOYMENT_NAME = 'retrohit-app'
    }

    tools {
        maven 'Maven 3.6.3'
        dockerTool 'Docker'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/retrohit/retrohit.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'sonar_token', variable: 'SONAR_TOKEN')]) {
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
        }

        stage('Build .jar') {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Push .jar to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials',
                                                usernameVariable: 'NEXUS_USER',
                                                passwordVariable: 'NEXUS_PASS')]) {
                configFileProvider([configFile(fileId: 'maven-settings', variable: 'MAVEN_SETTINGS')]) {
                    sh """
                    mvn --settings $MAVEN_SETTINGS deploy:deploy-file \
                        -DgroupId=com.retrohit \
                        -DartifactId=retrohit \
                        -Dversion=1.0-SNAPSHOT \
                        -Dpackaging=jar \
                        -Dfile=target/retrohit-1.0-SNAPSHOT.jar \
                        -DrepositoryId=nexus \
                        -Durl=http://<nexus-host>:8081/repository/maven-releases/
                    """
                   }
               }
           }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    docker build -t $DOCKER_IMAGE_NAME -f Dockerfile . 
                    '''
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker tag $DOCKER_IMAGE_NAME $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:latest
                        docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    kubectl config use-context kubernetes-admin@kubernetes
                    kubectl set image deployment/$K8S_DEPLOYMENT_NAME retrohit=$DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:latest --namespace=$K8S_NAMESPACE
                    kubectl rollout restart deployment/$K8S_DEPLOYMENT_NAME --namespace=$K8S_NAMESPACE
                    '''
                }
            }
        }

        stage('Expose to the Outside World (K8s Service)') {
            steps {
                script {
                    sh '''
                    kubectl expose deployment $K8S_DEPLOYMENT_NAME --type=LoadBalancer --name=retrohit-service --namespace=$K8S_NAMESPACE
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
