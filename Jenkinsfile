pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "saicharan6771/retrohit"
        REGISTRY = "https://index.docker.io/v1/"
        NEXUS_REPO = "maven-releases"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/saicharan621/retrohit.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis here
                    sh 'mvn sonar:sonar -Dsonar.projectKey=retrohit -Dsonar.host.url=http://3.110.104.81:9000'
                }
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    // Build the Java application into a .jar file
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image from the .jar file
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                        sh 'docker push $DOCKER_IMAGE'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy Docker container to Kubernetes (EKS)
                    sh 'kubectl apply -f k8s/deployment.yaml'
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful"
        }
        failure {
            echo "Deployment Failed"
        }
    }
}
