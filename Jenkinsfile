pipeline {
    agent any 
    stages {
        stage('Create New Environment') { 
            steps {
                sh '''
                  rm -r /home/ubuntu/.kube
                  mkdir /home/ubuntu/.kube
                  chmod -R 777 /home/ubuntu/.kube 
                  tfaws output -state /workspace/terraform.tfstate -raw kube_config > /home/ubuntu/.kube/config
                  chmod -R 400 ~/.kube/config
                  chmod -R go-r ~/.kube/config
                '''
            }
        }
        stage('Deploy SASViya4') { 
            steps {
                sh '''
                  alias viya4-deployment="docker container run -it --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/project/deploy:/data -v /home/ubuntu/.kube/config:/config/kubeconfig -v /home/ubuntu/project/deploy/sasviya4aws/sasviya4aws-viyavars.yaml:/config/config -v /home/ubuntu/viya4-iac-aws/terraform.tfstate:/config/tfstate viya4-deployment"
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