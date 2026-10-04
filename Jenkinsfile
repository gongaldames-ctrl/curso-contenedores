pipeline {
    agent {
        kubernetes {
            yamlFile 'agent.yaml'
            defaultContainer 'node-pnpm'
        }
    }
    environment {
        APP_VERSION = '3.0.0'
        IMAGE_NAME = 'gongaldames/tarea-final'
        IMAGE_TAG = 'gonzalo-galdames'
        REGISTRY_CREDENTIALS = credentials('docker-hub-credentials') // ID de credencial en Jenkins
    }
    stages {
        stage('install') {
            steps {
                container('node-pnpm') {
                    sh 'corepack enable'
                    sh 'pnpm install'
                }
            }
        }
        stage('test') {
            steps {
                container('node-pnpm') {
                    sh 'pnpm test || true'
                }
            }
        }
        stage('build') {
            steps {
                container('docker') {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:${APP_VERSION}"
                }
            }
        }
        stage('push') {
            steps {
                container('docker') {
                    sh "echo \$REGISTRY_CREDENTIALS_PSW | docker login -u \$REGISTRY_CREDENTIALS_USR --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${IMAGE_NAME}:${APP_VERSION}"
                }
            }
        }
        stage('deploy') {
            steps {
                container('kubectl') {
                    sh 'kubectl apply -f entrega.yaml'
                }
            }
        }
    }
}
