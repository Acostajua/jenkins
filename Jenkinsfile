pipeline {
  agent any

  environment {
    IMAGE_NAME = 'node-app:latest'
    REMOTE_HOST = 'azureuser@20.63.90.185'
    REMOTE_PATH = '/home/azureuser/app'
    SSH_KEY = credentials('ssh-key-id') // Asegúrate que este ID está creado en Jenkins como tipo "SSH Username with private key"
  }

  stages {
    stage('Preparar entorno') {
      steps {
        echo '✅ Iniciando pipeline...'
        sh 'echo $IMAGE_NAME'
      }
    }

    stage('Clonar repositorio') {
      steps {
        checkout scm
      }
    }

    stage('Construir imagen Docker') {
      steps {
        script {
          sh 'docker build -t $IMAGE_NAME .'
        }
      }
    }

    stage('Empaquetar proyecto') {
      steps {
        script {
          sh 'tar -czf deploy.tar.gz Dockerfile docker-compose.yml package*.json .env src/'
        }
      }
    }

    stage('Transferir archivos a la VM') {
      steps {
        script {
          sh '''
            ssh -i $SSH_KEY -o StrictHostKeyChecking=no $REMOTE_HOST "mkdir -p $REMOTE_PATH"
            scp -i $SSH_KEY -o StrictHostKeyChecking=no deploy.tar.gz $REMOTE_HOST:$REMOTE_PATH
          '''
        }
      }
    }

    stage('Desplegar en la VM') {
      steps {
        script {
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
  }

  post {
    success {
      echo '✅ Despliegue completado con éxito en Azure VM.'
    }
    failure {
      echo '❌ Error en el pipeline. Revisa los logs.'
    }
  }
}

