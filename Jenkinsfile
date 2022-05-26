pipeline {
    agent any 
    stages {
        stage('Create New Environment') { 
            steps {
                sh '''
                  alias tfaws="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws"
                  tfaws output -state /workspace/terraform.tfstate -json > output.json
                  export NS="sasviya4aws"
                  echo $Home
                  ./nfs.sh
                  mkdir $Home/.kube
                  chmod -R 777 $Home/.kube 
                  tfaws output -state /workspace/terraform.tfstate -raw kube_config > $Home/.kube/config
                  chmod -R 400 $Home/.kube/config
                  chmod -R go-r $Home/.kube/config
                '''
            }
        }
        stage('Deploy SASViya4') { 
            steps {
                sh '''
                  cp -r viya4-deployment/site-config/. /home/ubuntu/project/deploy/sasviya4aws/site-config/.
                  cp viya4-deployment/sasviya4aws-viyavars.yaml /home/ubuntu/project/deploy/sasviya4aws/sasviya4aws-viyavars.yaml
                  alias viya4-deployment="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/project/deploy:/data -v $Home/.kube/config:/config/kubeconfig -v /home/ubuntu/project/deploy/sasviya4aws/sasviya4aws-viyavars.yaml:/config/config -v /home/ubuntu/viya4-iac-aws/terraform.tfstate:/config/tfstate viya4-deployment"
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