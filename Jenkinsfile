pipeline {
  agent any

  environment {
    IMAGE_TAG = 'latest'
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout([
          $class: 'GitSCM',
          branches: [[name: '*/Hemath']],
          userRemoteConfigs: [[
            url: 'https://github.com/Sedin-hemakumar/Buggy-ECS.git',
            credentialsId: 'Github password'
          ]]
        ])
      }
    }

    stage('Docker Login to ECR') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS access key ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS secret access key', variable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'AWS session token', variable: 'AWS_SESSION_TOKEN'),
          string(credentialsId: 'AWS_REGION', variable: 'AWS_REGION'),
          string(credentialsId: 'ECR_REGISTRY', variable: 'ECR_REGISTRY')
        ]) {
          sh '''
            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
            export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}

            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
          '''
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        withCredentials([
          string(credentialsId: 'ECR_REGISTRY', variable: 'ECR_REGISTRY'),
          string(credentialsId: 'IMAGE_NAME', variable: 'IMAGE_NAME')
        ]) {
          sh '''
            docker build --no-cache -f Dockerfile.app -t ${IMAGE_NAME}:${IMAGE_TAG} .
            docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Push Image to ECR') {
      steps {
        withCredentials([
          string(credentialsId: 'ECR_REGISTRY', variable: 'ECR_REGISTRY'),
          string(credentialsId: 'IMAGE_NAME', variable: 'IMAGE_NAME')
        ]) {
          sh '''
            docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Deploy to ECS') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS access key ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS secret access key', variable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'AWS session token', variable: 'AWS_SESSION_TOKEN'),
          string(credentialsId: 'AWS_REGION', variable: 'AWS_REGION'),
          string(credentialsId: 'ECS_CLUSTER', variable: 'ECS_CLUSTER'),
          string(credentialsId: 'ECS_SERVICE', variable: 'ECS_SERVICE')
        ]) {
          sh '''
            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
            export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}

            aws ecs update-service \
              --cluster ${ECS_CLUSTER} \
              --service ${ECS_SERVICE} \
              --force-new-deployment \
              --region ${AWS_REGION}
          '''
        }
      }
    }
  }
}
