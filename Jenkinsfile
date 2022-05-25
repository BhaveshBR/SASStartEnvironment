pipeline {
    agent any 
    stages {
        stage('Start New Environment') { 
            steps {
                sh '''
                  alias tfaws="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws"
                '''
                sh '''
                  tfaws --version
                '''
            }
        }
    }
}