pipeline {
    agent any
    
    stages {
        stage('Checkout Github') {
            steps {
                // Task: checkout the github code
                git branch: 'main', url: 'https://github.com/kishinnn/csit314_final.git'
            }
        }
        
        stage('Stage 1: Build Jar') {
            steps {
                // Matches the command in your diagram
                sh './mvnw clean install -DskipTests'
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
                    // We pass the credentials via command line properties
                    sh """
                        ./mvnw deploy -DskipTests \
                        -DrepositoryId=nexus \
                        -Durl=http://nexus-service:8081/repository/maven-releases/ \
                        -Dusername=${NEXUS_USER} \
                        -Dpassword=${NEXUS_PWD}
                    """ 
            }
        }
        
        stage('Stage 3: Deploy to K8s Pod') {
            steps {
                sh 'echo "Updating Kubernetes Deployment..."'
                // In a real environment, you would use a K8s plugin or kubectl here
                // sh 'kubectl rollout restart deployment/helloworld-webapp'
            }
        }
    }
}