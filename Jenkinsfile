pipeline {
  agent any

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
        sh 'docker build -t node-app:latest .'
      }
    }

    stage('Empaquetar archivos') {
      steps {
        sh 'tar -czf deploy.tar.gz Dockerfile docker-compose.yml package*.json index.js'
      }
    }

    stage('Transferir a la VM') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-id', keyFileVariable: 'SSH_KEY')]) {
          sh '''
            ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no azureuser@20.63.90.185 "mkdir -p /home/azureuser/app"
            scp -i "$SSH_KEY" -o StrictHostKeyChecking=no deploy.tar.gz azureuser@20.63.90.185:/home/azureuser/app/
          '''
        }
      }
    }

    stage('Desplegar en VM Azure') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-id', keyFileVariable: 'SSH_KEY')]) {
          sh '''
            ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no azureuser@20.63.90.185 "
              cd /home/azureuser/app &&
              tar -xzf deploy.tar.gz &&
              docker compose down || true &&
              docker compose up -d --build
            "
          '''
        }
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
