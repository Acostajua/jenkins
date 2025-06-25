pipeline {
  agent any

  environment {
    IMAGE_NAME = 'node-app:latest'
    REMOTE_USER = 'azureuser'
    REMOTE_HOST = '20.63.90.185'
    REMOTE_PATH = '/home/azureuser/app'
    SSH_KEY = credentials('ssh-key-id') // Reemplaza con el ID real en Jenkins
  }

  stages {
    stage('Inicio') {
      steps {
        echo '✅ Iniciando pipeline...'
      }
    }

    stage('Clonar repositorio') {
      steps {
        checkout scm
      }
    }

    stage('Construir imagen Docker') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Empaquetar archivos') {
      steps {
        sh 'tar -czf deploy.tar.gz Dockerfile docker-compose.yml package*.json .env index.js'
      }
    }

    stage('Transferir a la VM') {
      steps {
        sh '''
          ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST "mkdir -p $REMOTE_PATH"
          scp -i "$SSH_KEY" -o StrictHostKeyChecking=no deploy.tar.gz $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/
        '''
      }
    }

    stage('Desplegar en VM Azure') {
      steps {
        sh '''
          ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST "
            cd $REMOTE_PATH &&
            tar -xzf deploy.tar.gz &&
            docker compose down || true &&
            docker compose up -d --build
          "
        '''
      }
    }
  }

  post {
    success {
      echo '✅ Despliegue completado exitosamente en Azure.'
    }
    failure {
      echo '❌ Falló el pipeline. Revisa los logs.'
    }
  }
}
