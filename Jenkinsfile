pipeline {
    agent any 
    stages {
        stage('Deploy SASViya4') { 
            steps {
                sh '''
                  alias viya4-deployment="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/project/deploy:/data -v /home/ubuntu/.kube/config:/config/kubeconfig -v /home/ubuntu/project/deploy/sasviya4aws/sasviya4aws-viyavars.yaml:/config/config -v /home/ubuntu/viya4-iac-aws/terraform.tfstate:/config/tfstate viya4-deployment"
                  viya4-deployment --tags "baseline,viya,install"
                '''
            }
        }
        stage('Run Test Cases') { 
            steps {
                sh '''
                  echo "Run Test Cases"
                '''
            }
        }
    }
}