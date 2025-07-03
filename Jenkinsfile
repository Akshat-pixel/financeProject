pipeline{
    agent any
    stages{
        stage('Fetch Code'){
            steps{
                git branch: 'main', url:'https://github.com/Akshat-pixel/financeProject.git'
            }
        }
        stage('Build Docker Image and Push to Docker Hub'){
            steps{
                script{
                    def image = docker.build("11akshat/financeproject:${env.BUILD_NUMBER}")
                    docker.withRegistry('https://index.docker.io/v1/', 'dockercred') {
                        image.push()
                    }
                }
            }              
        }

        stage('Delete old images')
        {
            steps{
                script{
                    sh '''
                        docker images 11akshat/financeproject --format '{{.Repository}}:{{.Tag}}' | \
                        grep -v '${env.BUILD_NUMBER}' | \
                        xargs -r docker rmi
                    '''
                }
            }
        }

        stage('start a new server using terraform'){
            steps{
                dir('terraform'){
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('get public ip of the server'){
            steps{
                script{
                    def privateip
                    dir('terraform'){
                        privateip = sh(
                            script: 'terraform output -raw private_ip',
                            returnStdout: true
                        ).trim()
                    }
                    env.PRIVATE_IP = privateip
                }
            }
        }
        stage('Passing the public ip to ansible role'){
            steps{
                script{
                    def content = readFile('inventory.yaml')
                    content = content.replace('PRIVATE_IP', env.PRIVATE_IP)
                    writeFile file: 'inventory.yaml', text: content
                    withCredentials([file(credentialsId: 'finance-key.pem', variable: 'PEM_FILE')]) {
                        sh 'cp $PEM_FILE ./finance-key.pem'
                        sh 'chmod 600 ./finance-key.pem'
                    }
                }
            }
        }
        stage('Run Ansible Playbook to install docker on the server'){
            steps{
                script{
                    sh 'sleep 60'
                    def version = env.BUILD_NUMBER as Integer
                    def prev_version = version - 1
                    sh '''ansible-playbook -i inventory.yaml  playbook.yaml \
                        -e VERSION=${version} \
                        -e PREV_VERSION=${prev_version}'''
                }
            }
        }
    }
}