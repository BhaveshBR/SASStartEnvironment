pipeline {
    agent any 
    stages {
        stage('Create New Environment') { 
            CLUSER_STATUS = sh (
                script: 'aws eks describe-cluster --name sinbrvk-eks | jq \'.cluster.status\'',
                returnStdout: true
            ).trim()
            echo "Cluster Status : ${CLUSER_STATUS}"
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh '''
                    # cp viya4-iac-aws/terraform.tfvars /home/ubuntu/viya4-iac-aws/terraform.tfvars
                    # rm -r -f /home/ubuntu/viya4-iac-aws/*.tfstate
                    # alias tfaws="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws"
                    # tfaws plan -var-file /workspace/terraform.tfvars -state workspace/terraform.tfstate
                    # tfaws apply -auto-approve -var-file /workspace/terraform.tfvars -state /workspace/terraform.tfstate
                    '''
                }
            }
        }
        stage('Get Environment Details') {
            steps {
                sh '''
                cp nfs.sh /home/ubuntu/nfs.sh
                chmod +x nfs.sh
                alias tfaws="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws"
                tfaws output -state /workspace/terraform.tfstate -json > output.json   
                export NS="sasviya4aws"
                ./nfs.sh  
                chmod -R 777 $HOME/.kube  
                rm -r $HOME/.kube       
                mkdir -p $HOME/.kube
                chmod -R 777 $HOME/.kube 
                tfaws output -state /workspace/terraform.tfstate -raw kube_config > $HOME/.kube/config
                chmod -R 400 $HOME/.kube/config
                chmod -R go-r $HOME/.kube/config
                '''
            }
        }
        stage('Deploy SASViya4') { 
            steps {
                sh '''
                  cp -r viya4-deployment/site-config/. /home/ubuntu/project/deploy/sasviya4aws/site-config/.
                  cp viya4-deployment/sasviya4aws-viyavars.yaml /home/ubuntu/project/deploy/sasviya4aws/sasviya4aws-viyavars.yaml
                  alias viya4-deployment="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/project/deploy:/data -v $HOME/.kube/config:/config/kubeconfig -v /home/ubuntu/project/deploy/sasviya4aws/sasviya4aws-viyavars.yaml:/config/config -v /home/ubuntu/viya4-iac-aws/terraform.tfstate:/config/tfstate viya4-deployment"
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