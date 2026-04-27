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
                    sh 'mvn clean install -DskipTests -Dhttps.protocols=TLSv1.2,TLSv1.3'
                }
            }
        }
        
        stage('Stage 2: Store to Nexus') {
            steps {
                // Use single quotes for credentialsId, but the SH command MUST use double quotes to expand the variables
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials', passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USER')]) {
                    sh "mvn deploy -DskipTests -DrepositoryId=nexus -Dusername=${NEXUS_USER} -Dpassword=${NEXUS_PWD}"
                }
            }
        }
    
        stage('Stage 3: Deploy to K8s Pod') {
            steps {
                // This block handles the connection to your cluster automatically
                withKubeConfig([credentialsId: 'kubeconfig-id']) {
                    sh "echo Updating Kubernetes Deployment..."
            
                    // This will now work because the plugin provides the context
                    sh "kubectl rollout restart deployment helloworld-webapp"
            
                    // Optional: Verify the status
                    sh "kubectl rollout status deployment helloworld-webapp"
                }
             }
        }
    } // This closes all stages
} // This closes the pipeline