pipeline{
    agent any
    parameters {
        string(name: 'Key', defaultValue: '', description: 'Enter key to login into instance')
    }
    stages{
        stage('Fetch Code'){
            steps{
                git branch: 'main', url:'https://github.com/Akshat-pixel/financeProject.git'
            }
        }
        stage('Build Docker Image and Push to Docker Hub'){
            steps{
                script{
                    def image = docker.build("11akshat/financeproject:latest")
                    docker.withRegistry('https://index.docker.io/v1/', 'dockercred') {
                        image.push()
                    }
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
                    def publicip
                    dir('terraform'){
                        publicip = sh(
                            script: 'terraform output -raw public_ip',
                            returnStdout: true
                        ).trim()
                    }
                    env.PUBLIC_IP = publicip
                }
            }
        }
        stage('Passing the public ip to ansible role'){
            steps{
                script{
                    def content = readFile('inventory.yaml')
                    content = content.replace('PUBLIC_IP', env.PUBLIC_IP)
                    writeFile file: 'inventory.yaml', text: content
                    def key = params.Key
                    writeFile file: 'key.pem', text: key
                }
            }
        }
        stage('Run Ansible Playbook to install docker on the server'){
            steps{
                script{
                    sh 'ansible-playbook -i inventory.yaml  playbook.yaml'
                }
            }
        }
    }
}