pipeline {
    agent any 
    stages {
        stage('Start New Environment') { 
            steps {
                sh '''
		  docker images
		'''
            }
        }
    }
}