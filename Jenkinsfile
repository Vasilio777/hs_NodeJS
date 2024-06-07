pipeline {
    agent any
    
    stages {
    	stage('Install dependencies') {
    		steps {
    			sh '''
    			curl -fsSL https://deb.nodesourse.com/setup_21.x | sudo -E bash -
    			sudo apt-get install -y nodejs
    			node -v
    			npm -v
    			npm install
    			'''
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
