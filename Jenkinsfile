pipeline {
  environment {
    registry = "registry.hub.docker.com"
    registryCredential = 'dockerhub'
  }
    agent { label 'jenkins-jenkins-slave ' }
    stages {
        stage("Cloning Git Repo") {
        steps {
            git "https://github.com/robmaynardjr/SC-Test.git"
        }
        }

        stage("Building image") {
        steps{
            container('docker') {
                script {
                dockerImage = docker.build('robmaynard/sc-test:latest')
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

                        sh "docker login -u '${USER}' -p '${PASS}' '${registry}'"
                        def image = 'robmaynard/sc-test:latest'
                        image.push                        
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
                            imagePullAuth: new groovy.json.JsonBuilder([
                                username: USER,
                                password: PASSWORD,
                                ]).toString(),
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