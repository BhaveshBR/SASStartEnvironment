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
            if (CLUSTER_STATUS == "INACTIVE") 
            {
                steps {
                        echo "Cluster - ${CLUSTER_STATUS}"
                    }
            }
        }
    }
}