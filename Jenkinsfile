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
  }
  stage('Scan image with DSSC'){
    container('docker') {
      withCredentials([
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: 'ecr',
        accessKeyVariable: 'AWS_ACCESS_KEY',
        secretKeyVariable: 'AWS_SECRET_KEY'
      ]){
          smartcheckScan([
              imageName: '279773871986.dkr.ecr.us-east-2.amazonaws.com/sc-test:latest',
              smartcheckHost: "10.0.10.100",
              insecureSkipTLSVerify: true,
              smartcheckCredentialsId: "smart-check-jenkins-user",
              imagePullAuth: new groovy.json.JsonBuilder([
                aws: [
                  region: "us-east-2",
                  registry: "279773871986",
                  accessKeyID: 'AWS_ACCESS_KEY',
                  secretAccessKey: 'AWS_SECRET_KEY'
                ]
              ]).toString(),
          ])
      }
    }
  }
  stage('Deploy'){
    sh 'echo "Deployed to Cluster."'
  }
}