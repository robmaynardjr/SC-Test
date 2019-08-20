environment {
  image = "jenkins/jnlp-slave"
  registry = "robmaynard"
  repository = "sc-test"
  tag = "latest"
  dockerImage = ""
  podLabel = "jenkins-jenkins-slave "
  registryCredential = 'dockerhub'
}

node(podLabel) {
  stage('Cloning Git Repo') {
    git "https://github.com/robmaynardjr/SC-Test.git"
  }
  stage('Build Container Image'){
    container('docker') {
      script {
        dockerImage = docker.build((registry + "/" + repository + ":" + tag))
      }
    }
  }
  stage('Stage Container Image'){
    container('docker') {
      script {
        withCredentials([
          usernamePassword([
              credentialsId: "dockerhub",
              usernameVariable: "USER",
              passwordVariable: "PASSWORD",
          ])             
      ]){  
          docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
            dockerImage.push()
          }
        }
      }
    }
  }
  stage('Scan image with DSSC'){
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
  stage('Deploy'){
    sh 'echo "Deployed to Cluster."'
  }
}