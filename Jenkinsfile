pipeline {
    agent any

    environment {
    	NODEJS_VERSION = '21.x'
    	K8S_SERVER = '192.168.105.4'
    	DEPLOY_USER = 'vagrant'
    }
    
    stages {
    	stage('Install dependencies') {
    		steps {
    			sh 'npm install'
    		}
    	}

    	stage('Run unit test') {
    		steps {
    			sh 'npm test'
    		}
    	}
    	
		stage('Build') {
			steps {
				sh "docker build -t ${env.DOCKER_IMAGE} ."
			}
		}

		stage('Push Docker Image') {
			steps {
				withDockerRegistry([credentialsId: 'docker-credentials-id', url: '']) {
					sh "docker push ${env.DOCKER_IMAGE}"
				}
			}
		}
		
        stage('Deploy to staging') {
        	steps {
        		ansiblePlaybook(
        			becomeUser: 'vagrant',
        			installation: 'ansible',
        			disableHostKeyChecking: true,
        			playbook: 'deploy-staging.yml',
        			inventory: 'inventory',
        			extraVars: [
        				TARGET_PATH: "${env.TARGET_PATH}",
        				DOCKER_IMAGE: "${env.DOCKER_IMAGE}"
        			],
        			vaultCredentialsId: 'ansible_pass'
        		)
        	}
        }
    }

    post {
    	always {
    		cleanWs()
    	}
    }
}
