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
                    def roleContent = readFile('roles/create_docker_image/tasks/main.yml')
                    roleContent = roleContent.replace('VERSION', "${env.BUILD_NUMBER}")
                    writeFile file: 'roles/create_docker_image/tasks/main.yml', text: roleContent
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
                    sh 'ansible-playbook -i inventory.yaml  playbook.yaml'
                }
            }
        }
    }
}