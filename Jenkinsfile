import groovy.json.JsonBuilder

pipeline {
  environment {
    registry = "registry.hub.docker.com"
    registryCredential = 'dockerhub'
    imgName = 'robmaynard/sc-test:latest'
    gitRepo = "https://github.com/robmaynardjr/SC-Test.git"
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
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {

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
                        ])             
                    ]){            
                        smartcheckScan([
                            imageName: "registry.hub.docker.com/robmaynard/sc-test:latest",
                            smartcheckHost: "10.0.10.100",
                            insecureSkipTLSVerify: true,
                            smartcheckCredentialsId: "smart-check-jenkins-user",
                            // imagePullAuth: new groovy.json.JsonBuilder([[
                            //     "username":"USER",
                            //     "password":"PASSWORD",
                            ]]).toString(),
                        ])
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