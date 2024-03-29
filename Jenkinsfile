pipeline {
    agent any 
    environment { 
        CLUSTER_STATUS = 'INACTIVE'
    }
    stages {
        stage('Check Environment') { 
            steps {
                script {
                    CLUSTER_STATUS = sh (
                        script: 'cd /home/ubuntu/.aws | aws eks describe-cluster --name sinbrvk-eks | jq \'.cluster.status\'',
                        returnStdout: true
                    ).trim()
                    echo "Cluster - ${CLUSTER_STATUS}"
                    //CLUSTER_STATUS = '"ACTIVE"'
                    if (CLUSTER_STATUS == '"ACTIVE"')
                    {
                        echo "Cluster is ACTIVE"
                    }
                    else
                    {
                        echo "Cluster is Not ACTIVE"
                        CLUSTER_STATUS = "INACTIVE"
                    }
                }
            }
        }
        stage('Create Environment')
        {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        if (CLUSTER_STATUS == 'INACTIVE')
                        {
                            sh '''
                                cp viya4-iac-aws/terraform.tfvars /home/ubuntu/viya4-iac-aws/terraform.tfvars
                                rm -r -f /home/ubuntu/viya4-iac-aws/*.tfstate
                                alias tfaws="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws"
                                tfaws plan -var-file /workspace/terraform.tfvars -state workspace/terraform.tfstate
                                tfaws apply -auto-approve -var-file /workspace/terraform.tfvars -state /workspace/terraform.tfstate
                            '''
                        }
                    }
                }
            }
        }
        stage('NFS Configure') {
            steps {
                sshagent (credentials: ['jumpuser']) {
                  sh '''
                  alias tfaws="docker container run --rm --group-add root --user $(id -u):$(id -g) -v /home/ubuntu/.aws:/.aws -v /home/ubuntu/.ssh:/.ssh -v /home/ubuntu/viya4-iac-aws:/workspace --entrypoint terraform viya4-iac-aws"
                  ip=$(tfaws output -state /workspace/terraform.tfstate -raw jump_public_ip)
                  ssh -o StrictHostKeyChecking=no -T jumpuser@$ip
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
                tfaws output -state /workspace/terraform.tfstate -json > /home/ubuntu/output.json   
                export NS="sasviya4aws"
                /home/ubuntu/nfs.sh  
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
                  viya4-deployment --tags "baseline,viya,cluster-logging,cluster-monitoring,viya-monitoring,install"
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
