pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID = 'ASIASJCHX6HE2VE5KW4K'
    AWS_SECRET_ACCESS_KEY = 'XQ9C74IVNKToCR2H8Uol0QTl8QYcII0CxPqb76CN'
    AWS_SESSION_TOKEN = 'IQoJb3JpZ2luX2VjEBsaCmFwLXNvdXRoLTEiSDBGAiEAte1v6E/bpvLDfSEtyC/R6UTmB5yexl2EL4++ZhBK2iICIQCJg+TymSo6vq6shs2YnSwrWTKumYWFK7cWr1dffhT5mSqcAwhEEAAaDDE1NjkxNjc3MzMyMSIMoIHMCLJ4mzETvBlQKvkC5k2bZsImyK6QhL/9QwDW5QHSjEtcbtuHoy8OIBOTxRxorw//nROLXTg05+seTIFQqhFwHxYyRZaKQJ3x7VcQzztMUhrtzDVG+AGhqVqA+IUeJWuGlbtejKhmMcj5f2Gnsb6/k92hpuPjq2VArFojobymdeiPhAovdXo6R3lEbsn8nEdllDuLjua5Ii9ykO7SJWF2u5wdZiGu4dBADPbjL1EGlVBALfejINr3YpRyWGqUpju0ioI4kF9SABjSwEE+v4E/FWlap2FI+7ssj3o+2B7WCp1IhggaRNUJeogPer+5YU8RAcip0t4MzQ29I6W9C9yxD38e2ZjXLqY5f0ATu1vM9u7DBdERfsf31Y06Kv7VNdWgp33tuZBr7FdLWOUckZpRvBcjp7/Qj0Zzhyfa9Gb9Ka3YZdNL0h6ZYb/ZcH1touTeJUkCCd8lo6YJOtdJCnsTUFM2NvzZawIACrAhynlqON6IazoSZXCbqoreDnwcwTEqGYcvucAwxM6NxAY6pQEp1dQNrtySbOWWJRijlzb5NCCn8bhWhA7Mdt/p64gqJS4A8SC5TFPyzybrYQRbfm19nZZlju2pEw8hV9h7C3Ot+RbkGBYPSZHS2tgvUZW282+9jGHK2bckQfi8C3y1msgi+TM9dpJrOO6GoR7TsXrsaAEBLNeELHnJaNKiR9J+uPaJC0ZCnhBD/GshjbCIAoqtXQucQ1CWnaryr3Z9YfSzaFbC3vw='
    AWS_REGION = 'ap-south-1'
    IMAGE_TAG = 'latest'
    ECR_REGISTRY = '156916773321.dkr.ecr.ap-south-1.amazonaws.com'
    IMAGE_NAME = 'hemath-rails'
  }

  stages {
    stage('Checkout Code') {
      steps {
        git branch: 'Hemath', url: 'https://github.com/Sedin-hemakumar/Buggy-CICD.git'
      }
    }

    stage('Docker Login to ECR') {
      steps {
        sh '''
          export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
          export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
          export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}

          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
        '''
      }
    }

    stage('Build Docker Image') {
  steps {
    sh '''
      docker build --no-cache -f Dockerfile.app -t ${IMAGE_NAME}:${IMAGE_TAG} .
      docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
    '''
  }
}


    stage('Push Image to ECR') {
      steps {
        sh '''
          docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
        '''
      }
    }
    stage('Run with Docker Compose') {
  steps {
    sh '''
      docker rm -f Buggy_rails_app || true
      docker-compose down || true
      docker-compose up -d
    '''
  }
}

  }
}
