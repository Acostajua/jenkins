pipeline {
  agent any

  environment {
    IMAGE_NAME      = 'miapp:latest'
    CONTAINER_NAME  = 'miapp'
    REMOTE_HOST     = 'azureuser@20.200.121.124'
    REMOTE_PATH     = '/home/azureuser/app'
    SSH_KEY_ID      = 'llave-jenkins-vm'         // ID de la clave privada .pem en Jenkins
    GIT_CREDENTIALS = 'github-token'            // ID del token de GitHub en Jenkins
  }

  stages {

    stage('Clonar repo') {
      steps {
        checkout([
          $class: 'GitSCM',
          branches: [[name: '*/main']],
          userRemoteConfigs: [[
            url: 'https://github.com/Acostajua/jenkins.git',
            credentialsId: env.GIT_CREDENTIALS
          ]]
        ])
      }
    }

    stage('Construir imagen Docker') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Copiar archivos a la VM') {
      steps {
        sshagent(credentials: [env.SSH_KEY_ID]) {
          sh 'ssh -o StrictHostKeyChecking=no $REMOTE_HOST "mkdir -p $REMOTE_PATH"'
          sh 'scp -o StrictHostKeyChecking=no docker-compose.yml $REMOTE_HOST:$REMOTE_PATH'
        }
      }
    }

    stage('Desplegar en VM con Docker Compose') {
      steps {
        sshagent(credentials: [env.SSH_KEY_ID]) {
          sh 'ssh -o StrictHostKeyChecking=no $REMOTE_HOST "cd $REMOTE_PATH && docker-compose up -d --build"'
        }
      }
    }
  }
}
