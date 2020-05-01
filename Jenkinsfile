pipeline {
  agent any
  environment {
        image-name = 'base-ami-v1'
    }
  
  stages {
    stage('Create Packer AMI') {
        steps {
          withCredentials([
            usernamePassword(credentialsId: '28519c1b-4036-4fc1-961f-f92cf70853e7', usernameVariable: 'AWS_KEY', passwordVariable: 'AWS_SECRET')
          ]) {
            sh '''
              /usr/local/bin/packer build -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} -var ami_name= ${image-name} packer/packer.json
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
               terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET} -var ami-name=${image-name}
            '''
        }
      }
    }
  }
}
