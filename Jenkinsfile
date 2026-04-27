pipeline {
    agent any
    
    tools {
        // This MUST match the 'Name' you gave in Global Tool Configuration
        maven 'Maven 3' 
    }

    stages {
        stage('Checkout Github') {
            steps {
                // Task: checkout the github code
                git branch: 'main', url: 'https://github.com/kishinnn/csit314_final'
            }
        }
        
        stage('Stage 1: Build Jar') {
            steps {
                retry(3) {
                    // Added TLS flags to stabilize the SSL handshake
                    sh './mvnw clean install -DskipTests -Dhttps.protocols=TLSv1.2,TLSv1.3'
                }
            }
        }
        
        stage('Stage 2: Store to Nexus') {
            steps {
                // This block securely binds your Jenkins credentials to variables
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials', 
                                 passwordVariable: 'NEXUS_PWD', 
                                 usernameVariable: 'NEXUS_USER')]) {
            
                    echo "Pushing jar to Nexus as ${NEXUS_USER}..."
            
                    // The command to upload the JAR using Maven
                    sh """
                        ./mvnw deploy -DskipTests \
                        -DrepositoryId=nexus \
                        -Durl=http://nexus-service:8081/repository/maven-releases/ \
                        -Dusername=${NEXUS_USER} \
                        -Dpassword=${NEXUS_PWD}
                    """ 
                } // This closes withCredentials
            } // This closes steps
        } // This closes stage
        
        stage('Stage 3: Deploy to K8s Pod') {
            steps {
                sh 'echo "Updating Kubernetes Deployment..."'
                // Re-running this ensures the pods pull the newest image
                sh 'kubectl rollout restart deployment helloworld-webapp'
            }
        }
    } // This closes all stages
} // This closes the pipeline