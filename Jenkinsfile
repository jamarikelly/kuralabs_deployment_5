pipeline {
	pipeline {
  		agent any
		environment {
    		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
 	 }
	agent any
   	 stages {
     	   stage('Build') {
            steps {
                sh '''#!/bin/bash
                python3 -m venv test3
                source test3/bin/activate
                pip install pip --upgrade
                cd app
                pip install -r requirements.txt
                export FLASK_APP=app
                flask run &
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''#!/bin/bash
                source test3/bin/activate
                py.test --verbose --junit-xml test-reports/results.xml
                '''
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        
        stage('Test2'){
      steps{
          echo "Testing"
      }
     }
       stage('Create container') {
            agent {
                label 'dockerDeploy'
            }
            steps {
                 sh '''#!/bin/bash
	            sudo usermod -a -G docker jenkins	  
                docker build -t deployment5:latest .
                '''
            }
        }
        stage('Push to Dockerhub') {
                agent {
                    label 'dockerDeploy'
                }
                steps {
                    sh '''#!/bin/bash
                    sudo docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
                    sudo docker images
                    sudo docker tag url-shortener_main_nginx:latest jamarik/d5_nginx:latest
                    sudo docker tag url-shortener_main_gunicorn-flask:latest jamarik/d5_gunicorn-pythonflask:latest
                    sudo docker push jamarik/d5_nginx:latest
                    sudo docker push jamarik/d5_gunicorn-pythonflask:latest
                    '''
                }
        }
        stage('Terraform - Deploy to ECS') {
            agent {
                label 'terraformDeploy'
            }
                steps {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                    string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                        dir('intTerraform') {
                            sh 'terraform init'
                            sh 'terraform plan -out tfplan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                            sh 'terraform show -no-color tfplan.tfplan > tfplan.txt'
                            sh 'terraform apply tfplan.tfplan'
                            sh 'sleep 400'
                        }
                    }
                }
        }
        stage('Terraform - Destroy ECS') {
            agent {
                label 'terraformDeploy'
            }
                steps {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                    string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                        dir('intTerraform') {
                            sh 'terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                        }
                    }
                }
        }
    }
}
