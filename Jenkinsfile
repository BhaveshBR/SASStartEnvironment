pipeline {
    agent any 
    stages {
        stage('Start New Environment') { 
            steps {
                sh '''
		  cat /home/ubuntu/.ssh/id_rsa
		'''
            }
        }
    }
}