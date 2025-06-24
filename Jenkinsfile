pipeline {
  agent any

  environment {
    IMAGE_NAME = 'miapp:latest'
    REMOTE_HOST = 'juan@192.168.1.25'
    REMOTE_PATH = '/home/juan/app'
    SSH_KEY = credentials('ssh-key-id') // Guardar en Jenkins la clave privada SSH con ese ID
  }

  stages {
    stage('Clonar repositorio') {
      steps {
        echo 'Repositorio clonado automáticamente por Jenkins.'
      }
    }

    stage('Construir imagen Docker') {
      steps {
        script {
          sh 'docker build -t $IMAGE_NAME .'
        }
      }
    }

    stage('Subir archivos por SSH') {
      steps {
        script {
          // Copia los archivos docker-compose y app
          sh '''
            ssh -i $SSH_KEY -o StrictHostKeyChecking=no $REMOTE_HOST 'mkdir -p $REMOTE_PATH'
            scp -i $SSH_KEY -o StrictHostKeyChecking=no docker-compose.yml $REMOTE_HOST:$REMOTE_PATH/
            scp -i $SSH_KEY -o StrictHostKeyChecking=no -r . $REMOTE_HOST:$REMOTE_PATH/
          '''
        }
      }
    }

    stage('Desplegar en VM') {
      steps {
        script {
          sh "ssh -i $SSH_KEY -o StrictHostKeyChecking=no $REMOTE_HOST 'cd $REMOTE_PATH && docker-compose down && docker-compose up -d --build'"
        }
      }
    }
  }

  post {
    success {
      echo 'Despliegue completado con éxito.'
    }
    failure {
      echo 'Algo falló en el pipeline.'
    }
  }
}
