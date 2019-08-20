def image = "jenkins/jnlp-slave"
def registry = "https://279773871986.dkr.ecr.us-east-2.amazonaws.com"
def repository = "sc-test"
def registryCredential = 'ecr:us-east-2:ecr'
def dockerImage = ""
def podLabel = "jenkins-jenkins-slave "


node(podLabel) {
  stage('Cloning Git Repo') {
    git "https://github.com/robmaynardjr/SC-Test.git"
  }
  stage('Build Container Image'){
    container('docker') {
      script {
        dockerImage = docker.build('279773871986.dkr.ecr.us-east-2.amazonaws.com/sc-test:latest')
      }
    }
  }
  stage('Stage Container Image'){
    container('docker') {
      script {
        docker.withRegistry((registry + "/" + repository), registryCredential ) {
          dockerImage.push()
        }
    }
  }
  stage('Scan image with DSSC'){
    container('docker') {
      withCredentials([
          usernamePassword([
              credentialsId: "sc-ecr",
              usernameVariable: "ECR_CRED_USR",
              passwordVariable: "ECR_CRED_PSW",
          ])
      ]){
          smartcheckScan([
              imageName: '279773871986.dkr.ecr.us-east-2.amazonaws.com/sc-test:latest',
              smartcheckHost: "10.0.10.100",
              insecureSkipTLSVerify: true,
              smartcheckCredentialsId: "smart-check-jenkins-user",
              imagePullAuth: new groovy.json.JsonBuilder([
                        username: ECR_CRED_USR,
                        password: ECR_CRED_PSW,
                        ]).toString(),
              ]).toString(),
          ])
      }
  }


        // Parameters for Smart Check scan function 
        // def config = [
        //   registry: registry,
        //   repository: repository,
        //   tag: "latest"
        // ]
        // // Adds AWS ECR Credentials to config
        // withCredentials([[
        //   $class: 'AmazonWebServicesCredentialsBinding', 
        //   credentialsId: 'ecr', 
        //   accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
        //   secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        //   ]]) {
        //     config.registryAccessKey = AWS_ACCESS_KEY_ID
        //     config.registrySecret = AWS_SECRET_ACCESS_KEY
        //   }

        // scanImage(config)
      }  
    }
  
  stage('Deploy'){
    sh 'echo "Deployed to Cluster."'
  }
}
