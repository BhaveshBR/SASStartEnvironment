pipeline {
    agent any 
    stages {
        stage('Start New Environment') { 
            steps {
                sh '''
		  docker container run --rm --group-add root --user $(id -u):$(id -g) -v $HOME/.aws:/.aws -v $HOME/.ssh:/.ssh -v $HOME/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws plan -var-file /workspace/sasviya4aws.tfvars -state workspace/terraform.tfstate
		'''
		sh '''
     		  docker container run --rm --group-add root --user $(id -u):$(id -g) -v $HOME/.aws:/.aws -v $HOME/.ssh:/.ssh -v $HOME/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws apply -auto-approve -var-file /workspace/sasviya4aws.tfvars -state /workspace/terraform.tfstate
		'''
            }
        }
        stage('Configure NFS') { 
            steps {
		sh "cd /home/ubuntu"
		sh "docker container run --rm --group-add root --user $(id -u):$(id -g) -v $HOME/.aws:/.aws -v $HOME/.ssh:/.ssh -v $HOME/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws output -state /workspace/terraform.tfstate -json > output.json"
       		sh "NS=sasviya4aws"
 		sh "./nfs.sh"
            }
        }
        stage('Deploy SAS Viya'){
            steps {
             	sh '''
		  docker container run -it --group-add root --user $(id -u):$(id -g) -v $HOME/project/deploy:/data -v $HOME/.kube/config:/config/kubeconfig -v $HOME/project/deploy/sasviya4aws/sasviya4aws-viyavars.yaml:/config/config -v $HOME/viya4-iac-aws/terraform.tfstate:/config/tfstate viya4-deployment --tags "baseline,viya,install"
		'''
            }
        }
    }
}