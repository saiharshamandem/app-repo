pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = credentials('AWS_ACCOUNT_ID')
        AWS_REGION = credentials('AWS_REGION')
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        GITHUB_TOKEN = credentials('GITHUB_TOKEN')
        MANIFEST_REPO_URL = "github.com/<MY_GITHUB_USERNAME>/k8s-manifests-repo.git"
    }

    stages {
        stage('Determine Environment') {
            steps {
                script {
                    // Normalize the branch name (works for GIT_BRANCH and BRANCH_NAME)
                    def branch = env.BRANCH_NAME ?: env.GIT_BRANCH.replace('origin/', '')
                    if (branch == 'dev') {
                        env.ENV_NAME = 'dev'
                        env.ECR_REPO = 'person-search-dev'
                    } else if (branch == 'preprod') {
                        env.ENV_NAME = 'preprod'
                        env.ECR_REPO = 'person-search-preprod'
                    } else {
                        error("Unsupported branch: ${branch}")
                    }
                    def shortCommit = env.GIT_COMMIT.take(7)
                    env.IMAGE_TAG = "${env.ENV_NAME}-${shortCommit}"
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build("${env.ECR_REGISTRY}/${env.ECR_REPO}:${env.IMAGE_TAG}")
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                script {
                    // Authenticate to ECR using IAM Role attached to EC2
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    dockerImage.push()
                }
            }
        }

        stage('Update K8s Manifests') {
            steps {
                script {
                    // Update the image tag in the manifests repo and push
                    sh """
                        rm -rf k8s-manifests-repo-update || true
                        git clone https://${GITHUB_TOKEN}@${MANIFEST_REPO_URL} k8s-manifests-repo-update
                        cd k8s-manifests-repo-update
                        
                        # Use sed to update image tag
                        sed -i.bak 's|image: .*|image: ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}|' ${env.ENV_NAME}/deployment.yaml
                        rm ${env.ENV_NAME}/deployment.yaml.bak
                        
                        git config user.email "jenkins@example.com"
                        git config user.name "Jenkins CI"
                        git add ${env.ENV_NAME}/deployment.yaml
                        git commit -m "Update ${env.ENV_NAME} image to ${IMAGE_TAG}"
                        git push https://${GITHUB_TOKEN}@${MANIFEST_REPO_URL} main
                    """
                }
            }
        }
    }
}
