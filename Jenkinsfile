pipeline {
    agent any 
    stages {
        stage('Start New Environment') { 
            steps {
                sh '''
                  alias tfaws="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws"
                  tfaws plan -var-file /workspace/sasviya4aws.tfvars -state workspace/terraform.tfstate
                  tfaws apply -auto-approve -var-file /workspace/sasviya4aws.tfvars -state /workspace/terraform.tfstate
                  tfaws output -state /workspace/terraform.tfstate > /home/ubuntu/output.json
                '''
            }
        }
    }
}