pipeline {
  environment {
    registry = "registry.hub.docker.com"
    registryCredential = 'dockerhub'
    imgName = 'robmaynard/sc-test:latest'
    gitRepo = "https://github.com/robmaynardjr/SC-Test.git"
    smartCheckHost = "10.0.10.100"
    imgPAuth = (groovy.json.JsonBuilder(["username":"${USER}","password":"${PASSWORD}"]).toString)
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
                        usernamePassword([
                            credentialsId: "dockerhub",
                            usernameVariable: "USER",
                            passwordVariable: "PASSWORD",
                        ]),
                        usernamePassword([
                            credentialsId: "smart-check-jenkins-user",
                            usernameVariable: "SCUSER",
                            passwordVariable: "SCPASSWORD",
                        ])   
                    ]){
                        sh "docker login -u '${USER}' -p '${PASSWORD}'"
                        echo imgPAuth
                        sh "docker run deepsecurity/smartcheck-scan-action --image-name ${imgName} --smartcheck-host='${smartCheckHost}' --smartcheck-user='${SCUSER}' --smartcheck-password='${SCPASSWORD}' --insecure-skip-tls-verify --image-pull-auth=${imgPAuth}"
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