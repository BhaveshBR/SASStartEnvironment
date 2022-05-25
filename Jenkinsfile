pipeline {
    agent any 
    stages {
        stage('Start New Environment') { 
            steps {
                sh '''
		   source /home/ubuntu/.bashrc
		'''
		sh '''
		   tfaws --version
		'''
		sh '''
		   viya4-deployment --version
		'''
            }
        }
    }
}