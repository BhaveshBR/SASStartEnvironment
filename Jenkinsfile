pipeline {
    agent any 
    stages {
        stage('Start New Environment') { 
            steps {
                sh "tfaws plan -var-file /workspace/sasviya4aws.tfvars -state workspace/terraform.tfstate"
		sh "tfaws apply -auto-approve -var-file /workspace/sasviya4aws.tfvars -state /workspace/terraform.tfstate"
            }
        }
        stage('Configure NFS') { 
            steps {
		sh "tfaws output -state /workspace/terraform.tfstate -json | jq -r '@sh \"export ipaddress=\(.jump_public_ip.value)\"' > env.sh"
		sh "source env.sh"
       		sh "NS=sasviya4aws"
 		sh "/home/ubuntu/nfs.sh
            }
        }
        stage('Deploy SAS Viya'){
            steps {
             	sh "viya4-deployment --tags \"baseline,viya,install\""
            }
        }
    }
}