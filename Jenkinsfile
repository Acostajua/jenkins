pipeline {
  agent any

  environment {
    IMAGE_NAME = 'miapp:latest'
    CONTAINER_NAME = 'miapp'
    REMOTE_HOST = 'azureuser@20.200.121.124'
    REMOTE_PATH = '/home/azureuser/app'
    SSH_KEY_ID = 'llave-jenkins-vm' // ID de la clave privada en Jenkins
  }

  stages {
    stage('Clonar repo') {
      steps {
        git 'https://github.com/tuusuario/turepo.git'
      }
    }

    stage('Construir imagen Docker') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Copiar archivos a la VM') {
      steps {
        sshagent (credentials: [env.SSH_KEY_ID]) {
          sh 'ssh -o StrictHostKeyChecking=no $REMOTE_HOST "mkdir -p $REMOTE_PATH"'
          sh 'scp -o StrictHostKeyChecking=no docker-compose.yml $REMOTE_HOST:$REMOTE_PATH'
        }
      }
    }

    stage('Desplegar en VM con Docker Compose') {
      steps {
        sshagent (credentials: [env.SSH_KEY_ID]) {
          sh "ssh -o StrictHostKeyChecking=no $REMOTE_HOST 'cd $REMOTE_PATH && docker compose up -d --build'"
        }
      }
    }
  }
}
