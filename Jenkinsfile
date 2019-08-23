pipeline {
  environment {
    registry = "registry.hub.docker.com"
    registryCredential = 'dockerhub'
    imgName = 'robmaynard/sc-test:latest'
    gitRepo = "https://github.com/robmaynardjr/SC-Test.git"
    smartCheckHost = "10.0.10.100"

  }
    agent { label 'jenkins-jenkins-slave ' }

    stages {
        stage("Cloning Git Repo") {
            steps {
                git gitRepo
            }
        }

        stage("Building image") {
            steps{
                container('docker') {
                    script {
                    dockerImage = docker.build(imgName)
                    }
                }
            }
        }

        stage("Stage Image") {
            steps{
                container('docker') {
                    script {
                        withCredentials([
                            usernamePassword([
                                credentialsId: 'dockerhub', 
                                passwordVariable: 'PASS', 
                                usernameVariable: 'USER',
                                ])
                            ]) {

                            // docker.withRegistry('', registryCredential ) {
                            //     dockerImage.push()
                            echo "Logging into Dockerhub..."
                            sh "docker login -u '${USER}' -p '${PASS}'"
                            echo "Pushing Image..."
                            sh "docker push ${imgName}"                       
                            }
                        }   
                    }
                }
            }
        

        stage("Security Check") {
            steps {
                container('docker') {
                    withCredentials([
                        credentialsId: "smart-check-jenkins-user",
                        usernameVariable: "SC-USER",
                        passwordVariable: "SC-PASSWORD",

                    ])
                    withCredentials([
                        usernamePassword([
                            credentialsId: "dockerhub",
                            usernameVariable: "USER",
                            passwordVariable: "PASSWORD",
                        ])             
                    ]){
                        sh "docker run deepsecurity/smart-check-scan-action --image-name ${imgName} --smartcheck-host='${smartCheckHost}' --smartcheck-user='${SC-USER}' --smartcheck-password='${SC-PASSWORD}' --insecure-skip-tls-verify --img-pull-auth={'username': USER, 'password': PASSWORD}"
                    }
                }
            }
        }
        stage ("Deploy to Cluster") {
        steps{
            echo "Function to be added at a later date."
                
            }
        }   
    }
}