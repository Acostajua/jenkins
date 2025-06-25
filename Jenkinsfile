pipeline {
  agent any

  environment {
    IMAGE_NAME = 'miapp:latest'
    REMOTE_HOST = 'azureuser@20.63.90.185'
    REMOTE_PATH = '/home/azureuser/app'
    SSH_KEY = credentials('ssh-key-id') // Agrega este en Jenkins (tipo "SSH Username with private key")
  }

  stages {
    stage('Construir imagen Docker') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Empaquetar proyecto') {
      steps {
        sh 'tar -czf deploy.tar.gz Dockerfile docker-compose.yml package*.json src/'
      }
    }

    stage('Transferir por SCP') {
      steps {
        sh '''
          ssh -i $SSH_KEY -o StrictHostKeyChecking=no $REMOTE_HOST "mkdir -p $REMOTE_PATH"
          scp -i $SSH_KEY -o StrictHostKeyChecking=no deploy.tar.gz $REMOTE_HOST:$REMOTE_PATH
        '''
      }
    }

    stage('Desplegar en Azure') {
      steps {
        sh '''
          ssh -i $SSH_KEY -o StrictHostKeyChecking=no $REMOTE_HOST "
            cd $REMOTE_PATH &&
            tar -xzf deploy.tar.gz &&
            docker compose down &&
            docker compose up -d --build
          "
        '''
      }
    }
  }

  post {
    success {
      echo '✅ Despliegue completado con éxito.'
    }
    failure {
      echo '❌ Algo falló en el pipeline.'
    }
  }
}
