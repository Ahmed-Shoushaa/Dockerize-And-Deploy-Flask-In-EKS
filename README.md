# Dockerize and Deploy Flask Application

## Project Overview

This project Dockerizes Flask Python application, provision a Kubernetes cluster on AWS using Terraform, and deploy the containerized microservice on that cluster. Additionally, it includes setting up a CI/CD pipeline with GitHub Actions to automate the build and deployment process, , ensuring seamless integration and delivery.
<p align="center">
  <img src="images\full-arch.png" alt="AWS Diagram" width="500"/>
</p>


## Table of Contents

- [Tech Stack](#technologies-used)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
    - [Provisioning the infrastructure](#provision_the_infrastructure)
    - [Application Dockerization and deployment](#application_dockerization_and_deployment)
        - [Using GitHub Actions](#using_github_actions)
        - [Manual build and deploy](#manual_build_and_deploy)

## Tech Stack

- **Flask**: A lightweight WSGI web application framework for Python.
- **Docker**: To containerize the Flask application.
- **Terraform**: To provision the Kubernetes cluster on AWS.
- **Kubernetes**: To orchestrate the deployment of the containerized application.
- **GitHub Actions**: To automate build and deploy process 
> [!NOTE]
> Seperate README.md file is added inside each folder to describe it's resources.

## Prerequisites
- Docker (optional)- [Installation Guide](https://docs.docker.com/engine/install/)
- Kubectl Utility (optional) - [Installation Guide](https://kubernetes.io/docs/tasks/tools/)
- AWS CLI - [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- EKSCTL Utility - [Installation Guide](https://eksctl.io/installation/)
- AWS acoount with valid Access keys
> Install optional Prerequisites in case of not using GitHub Actions

> I used AWS CloudShell during the process as it has most of these installed



## Getting Started
## 1. Provisioning the infrastructure:
Using the provided Terraform scripts will provision the following architecture
 
<p align="center">
  <img src="images\terraform-infra.png" alt="AWS Diagram" width="500"/>
</p>

1- Clone this repository to your machine:
   ```bash
   git clone https://github.com/ahmed-shoushaa/repo-name.git
   cd repo-name/manifests
   ```
2- Before running terraform commands create an `s3 bucket` to store the state file and update it's name in terraform/provider.tf or comment the entire block to locally store the state file 
<p align="center">
  <img src="images\s3.png" alt="s3 vars" width="400"/>
</p>
3- Review the plan and input the access keys in the prompt
<p align="center">
  <img src="images\keys-prompt.png" alt="terraform prompt" width="400"/>
</p>

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## 2. Application Dockerization and deployment:
You can fork this repo to Utilize the github\workflows files and automate the build and deploy proccess or follow the manual steps
### Using GitHub Actions
Pipeline gets triggered at each edit in `master` branch in the `code` folder
<p align="center">
  <img src="images\gh.png" alt="CI/CD" />
</p>
The deployment of the Flask application is managed through a CI/CD pipeline, which automates the process of building the Docker image, pushing to ecr and deploying it to the Kubernetes cluster.

Before triggering the pipeline follow these steps: 

1- Add Secrets to GitHub
- Navigate to your GitHub repository.
- Go to **Settings > Secrets and variables > Actions**.
- Add the required secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
<p align="center">
  <img src="images\secrets.png" alt="gh secret" width="700" />
</p>
2- Create an IAM Role for the AWS Load Balancer Controller which the pipeline will create inside the cluster

```bash
# Authenticate login to AWS using access keys 
aws configure

# Download an IAM policy for the AWS Load Balancer Controller that allows it to make calls to AWS APIs on your behalf.
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json

# Create an IAM policy using the policy downloaded in the previous step.
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

# Create IAM Role using eksctl
# Replace my-cluster with your cluster name
# Replace 111122223333  with your account id
eksctl create iamserviceaccount \
  --cluster=my-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::111122223333:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

3- Trigger the pipeline 

Once the pipeline completes successfully, the following resources will be deployed on your EKS
<p align="center">
  <img src="images\k8s-arch.png" alt="AWS Diagram" width="500"/>
</p>


### Manual build and deploy
1- configure AWS CLI credentials to authenticate reaching ecr
```bash
# Add the required credential keys and region in the prompt
aws configure
```
2- Authenticate with ECR

From AWS Console go the ECR Repo and choose `view push commands` and run the first command to authenticate login to ecr
```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
```
3- Build and push docker image
```bash
cd repo-name/code

docker build -t flask .

docker tag flask:latest <account-id>.dkr.ecr.<region>.amazonaws.com/flask:latest

docker push <account-id>.dkr.ecr.<region>.amazonaws.com
```
4- Verify the Image in ECR console from the image tab

5- Connect to EKS Cluster
```bash
aws configure
aws eks update-kubeconfig --region region-code --name eks-cluster
```
6- Create AWS Load Balancer Controller IAM Role: (Refer to step 2 in "Using GitHub Actions")

7- Install AWS Load Balancer Controller using HELM [Installation Details](https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html)
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 
# verify that the controller is installed
kubectl get deployment -n kube-system aws-load-balancer-controller
```

8- Install K8s Metrics server

This is needed to enable the Horizontal Pod Autoscaler to monitor resource usage.

```bash
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml

kubectl apply -f components.yaml
```

9- Deploy the Kubernetes Manifests:

from the directory that contains k8s manifests `./manifests/`
- Update spec.spec.containers.image value to with the ecr image
```bash
kubectl apply -f .
```