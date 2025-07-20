pipeline {
  agent any

  environment { 
    REPO_URL = 'https://github.com/rajendrakmr/bankapp.git'
    BRANCH = 'DevOps'
    IMAGE_NAME = 'bankapp'
    REGISTRY = 'docker.io'
    DOCKER_CREDENTIALS = 'dockerHubCreds'
    DOCKER_USERNAME = 'yourDockerHubUsername'  // <-- Set your DockerHub username here
  }

  parameters {
    string(name: 'IMAGE_TAG', defaultValue: '', description: 'Image tag to use. Defaults to build number.')
  }

  stages {
    stage('Clean Workspace') {
      steps {
        cleanWs()
      }
    }

    stage('Git: Clone Repository') {
      steps {
        git branch: "${BRANCH}", url: "${REPO_URL}"
      }
    }

    stage('Trivy: Filesystem & Image Scan') {
      steps {
        script { 
          sh 'trivy fs .'  
        }
      }
    }

    stage('OWASP: Dependency Check') {
      steps {
        dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP'
        dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
      }
    }

    stage('SonarQube: Code Analysis') {
      steps {
        withSonarQubeEnv('Sonar') {
          sh '''
            sonar-scanner \
              -Dsonar.projectKey=bankapp \
              -Dsonar.projectName=bankapp \
              -Dsonar.sources=. \
              -Dsonar.java.binaries=. \
              -X
          '''
        }
      }
    }

     

    stage('SonarQube: Quality Gate') {
      steps {
        timeout(time: 2, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    stage('Docker: Build Image') {
      steps {
        script {
          def tag = params.IMAGE_TAG ? params.IMAGE_TAG : "${BUILD_NUMBER}"
          env.IMAGE_TAG_FINAL = tag
          env.FULL_IMAGE_NAME = "${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG_FINAL}"
          sh "docker build -t ${FULL_IMAGE_NAME} ."
        }
      }
    }

    stage('DockerHub: Push Image') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "${DOCKER_CREDENTIALS}",
          usernameVariable: 'DOCKER_USERNAME',
          passwordVariable: 'DOCKER_PASSWORD'
        )]) {
          script {
            sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
            sh "docker push ${FULL_IMAGE_NAME}"
          }
        }
      }
    }
  }

  post { 
    success {
      archiveArtifacts artifacts: '*.xml', followSymlinks: false
      build job: "BankApp-CD", parameters: [
        string(name: 'DOCKER_TAG', value: "${IMAGE_TAG_FINAL}"),
        string(name: 'GIT_URL', value: "${REPO_URL}"),
        string(name: 'BRANCH_NAME', value: "${BRANCH}")
      ]
    }
  }
}
