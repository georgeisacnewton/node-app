pipeline {
  agent any
  stages {
    stage('Create Packer AMI') {
        steps {
          withCredentials([
            usernamePassword(credentialsId: '7aad0812-c537-434d-b700-77d3f6e19220', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY')
          ]) {
            sh 'echo ${AWS_KEY}; cd packer;packer build -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} packer.json'
        }
      }
    }
    stage('AWS Deployment') {
      steps {
          withCredentials([
            usernamePassword(credentialsId: '7aad0812-c537-434d-b700-77d3f6e19220', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY'),
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
