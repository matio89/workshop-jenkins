pipeline {
    agent any
    
    environment {
        DOCKER_OWNER = 'matio89'
        DOCKER_USER = 'matio89'
        DOCKER_TOKEN = credentials('dockerhub-firas-token')
        FRONT_IMG_TAG = sh( returnStdout:true,
                    script: 'sha256sum angular-app/package.json | cut -c1-15'
                  ).trim()
        BACK_IMG_TAG = sh( returnStdout:true,
                    script: 'sha256sum express-server/package.json | cut -c1-15'
                  ).trim()
        REPO_API_URL = 'https://registry.hub.docker.com/v2/repositories/'
    }
    
    stages {
        stage ('Preparing base image for front end') {
            steps {
                sh( returnStdout: false, script: """#!/bin/sh
                    res=\$(wget -O - --user ${env.DOCKER_USER} --password ${env.DOCKER_TOKEN} ${env.REPO_API_URL}/${env.DOCKER_OWNER}/matit-angular-front-base/tags | grep ${env.FRONT_IMG_TAG} )
                    if [ -z "\$res" ]; then
                        echo "Did not find image with tag ${env.FRONT_IMG_TAG}"
                        docker login -u ${env.DOCKER_USER} -p ${env.DOCKER_TOKEN}
                        docker build -f angular-app/base.Dockerfile -t ${env.DOCKER_OWNER}/matit-angular-front-base:${env.FRONT_IMG_TAG} angular-app/
                        docker push ${env.DOCKER_OWNER}/matit-angular-front-base:${env.FRONT_IMG_TAG}
                    else
                        echo "Found image with tag ${env.FRONT_IMG_TAG}"
                    fi
                    """.stripIndent()
                )
            }
        }
        stage ('Front end image build') {
            steps {
                sh "docker login -u ${env.DOCKER_USER} -p ${env.DOCKER_TOKEN}"
                sh "docker pull ${env.DOCKER_OWNER}/matit-angular-front-base:${env.FRONT_IMG_TAG}"
                sh "docker tag ${env.DOCKER_OWNER}/matit-angular-front-base:${env.FRONT_IMG_TAG} matit-angular-front-base:latest"
                sh "docker build --tag ${env.DOCKER_OWNER}/matit-angular-front:build-${env.BUILD_NUMBER} --file ./angular-app/Dockerfile ./angular-app/"
                sh "docker push ${env.DOCKER_OWNER}/matit-angular-front:build-${env.BUILD_NUMBER}"
                sh "docker tag ${env.DOCKER_OWNER}/matit-angular-front:build-${env.BUILD_NUMBER} ${env.DOCKER_OWNER}/matit-angular-front:latest"
                sh "docker push ${env.DOCKER_OWNER}/matit-angular-front:latest"
            }
        }
        stage ('Preparing base image for back end') {
            steps {
                sh( returnStdout: false, script: """#!/bin/sh
                    res=\$(wget -O - --user ${env.DOCKER_USER} --password ${env.DOCKER_TOKEN} ${env.REPO_API_URL}/${env.DOCKER_OWNER}/matit-express-back-base/tags | grep ${env.BACK_IMG_TAG} )
                    if [ -z "\$res" ]; then
                        echo "Did not find image with tag ${env.BACK_IMG_TAG}"
                        docker login -u ${env.DOCKER_USER} -p ${env.DOCKER_TOKEN}
                        docker build -f express-server/base.Dockerfile -t ${env.DOCKER_OWNER}/matit-express-back-base:${env.BACK_IMG_TAG} express-server/
                        docker push ${env.DOCKER_OWNER}/matit-express-back-base:${env.BACK_IMG_TAG}
                    else
                        echo "Found image with tag ${env.BACK_IMG_TAG}"
                    fi
                    """.stripIndent()
                )
            }
        }
        stage ('Back end image build') {
            steps {
                sh "docker login -u ${env.DOCKER_USER} -p ${env.DOCKER_TOKEN}"
                sh "docker pull ${env.DOCKER_OWNER}/matit-express-back-base:${env.BACK_IMG_TAG}"
                sh "docker tag ${env.DOCKER_OWNER}/matit-express-back-base:${env.BACK_IMG_TAG} matit-express-back-base:latest"
                sh "docker build --tag ${env.DOCKER_OWNER}/matit-express-back:build-${env.BUILD_NUMBER} --file ./express-server/Dockerfile ./express-server/"
                sh "docker push ${env.DOCKER_OWNER}/matit-express-back:build-${env.BUILD_NUMBER}"
                sh "docker tag ${env.DOCKER_OWNER}/matit-express-back:build-${env.BUILD_NUMBER} ${env.DOCKER_OWNER}/matit-express-back:latest"
                sh "docker push ${env.DOCKER_OWNER}/matit-express-back:latest"
            }
        }
        stage ('Trigger deployment'){
            steps{
                build job: 'matit-app-deployment', parameters: [], wait: false
            }
        }
    }
}
