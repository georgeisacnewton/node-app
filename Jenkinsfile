pipeline {
  agent any
  stages {
    stage('Create Packer AMI') {
        steps {
          withCredentials([
            usernamePassword(credentialsId: '28519c1b-4036-4fc1-961f-f92cf70853e7', usernameVariable: 'AWS_KEY', passwordVariable: 'AWS_SECRET')
          ]) {
            sh '''
             packer build -var aws_access_key=AKIAJR4HSCIMMAATFYGA -var aws_secret_key=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 packer/packer.json
            '''
        }
      }
    }
    stage('AWS Deployment') {
      steps {
          withCredentials([
            usernamePassword(credentialsId: '28519c1b-4036-4fc1-961f-f92cf70853e7', usernameVariable: 'AWS_KEY', passwordVariable: 'AWS_SECRET')
            // usernamePassword(credentialsId: '2facaea2-613b-4f34-9fb7-1dc2daf25c45', passwordVariable: 'REPO_PASS', usernameVariable: 'REPO_USER'),
          ]) {
            sh '''
               cd terraform
               terraform init
               terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET}
            '''
        }
      }
    }
  }
}
