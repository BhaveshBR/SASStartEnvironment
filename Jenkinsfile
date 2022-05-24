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
		sh "tfaws output -state /workspace/terraform.tfstate -json > /ome/ubuntu/output.json"
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