pipeline {
    agent any

    tools {
        maven 'Maven 3.6.3'
        dockerTool 'Docker'
    }

    environment {
        IMAGE_NAME = 'saicharan6771/retrohit:latest'
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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Push .jar to Nexus') {
            steps {
                sh """
                mvn deploy:deploy-file \
                    -DgroupId=com.retrohit \
                    -DartifactId=retrohit \
                    -Dversion=1.0-SNAPSHOT \
                    -Dpackaging=jar \
                    -Dfile=target/retrohit-1.0-SNAPSHOT.jar \
                    -DrepositoryId=nexus \
                    -Durl=http://52.66.91.138:8081/repository/snapshots/ \
                    -Dusername=retrohit \
                    -Dpassword=retrohit
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t retrohit -f Dockerfile .
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker tag retrohit $IMAGE_NAME
                        docker push $IMAGE_NAME
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
                    kubectl apply -f deployment.yaml --namespace=retrohit
                    kubectl set image deployment/retrohit-app retrohit=$IMAGE_NAME --namespace=retrohit
                    kubectl rollout restart deployment/retrohit-app --namespace=retrohit
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully.'
        }
        failure {
            echo '❌ Pipeline failed. Please check the logs.'
        }
    }
}
