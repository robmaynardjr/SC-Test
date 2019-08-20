pipeline {
  environment {
    registry = "robmaynard/sc-test-vuln"
    registryCredential = 'dockerhub'
  }

 node('jenkins-jenkins-slave ') {
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
                docker.withRegistry('https://registry.hub.docker.com', registryCredential ) {
                    dockerImage.push()
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
}