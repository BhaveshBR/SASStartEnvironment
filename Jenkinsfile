pipeline {
    agent any 
    stages {
        stage('Start New Environment') { 
            steps {
                sh '''
		  ls
		  docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws plan -var-file /workspace/sasviya4aws.tfvars -state workspace/terraform.tfstate
		'''
		sh '''
     		  docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws apply -auto-approve -var-file /workspace/sasviya4aws.tfvars -state /workspace/terraform.tfstate
		'''
            }
        }
        stage('Configure NFS') { 
            steps {
		sh "cd /home/ubuntu"
		sh '''
		  cd /home/ubuntu
		  docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v $HOME/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws output -state /workspace/terraform.tfstate -json > output.json
		export NS=sasviya4aws
	        /home/ubuntu/nfs.sh
		'''
            }
        }
        stage('Deploy SAS Viya'){
            steps {
             	sh '''
		  docker container run -it --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/project/deploy:/data -v /home/ubuntu/.kube/config:/config/kubeconfig -v /home/ubuntu/project/deploy/sasviya4aws/sasviya4aws-viyavars.yaml:/config/config -v /home/ubuntu/viya4-iac-aws/terraform.tfstate:/config/tfstate viya4-deployment --tags "baseline,viya,install"
		'''
            }
        }
    }
}