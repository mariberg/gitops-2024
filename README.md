## Gitops for Terraform

This project was created as part of the [GitOps for Terraform minicamp](https://courses.morethancertified.com/p/gitops-with-terraform). The idea of this project is to build a 
fully functional GitOps pipeline to deploy AWS infrastructure using Terraform.

This Terraform project creates a simple Grafana server with related resources such as internet gateway and route table. The purpose of this project is to concentrate on the pipeline and different functionalities that would ensure that the pipeline contains required mechanisms and quardrails to make sure that it will be used as intended.

The structure of this project is summarized in the below diagram:
!(Gitops_diagram)[assets/gitops_diagram.png]


The general principle of the Pipeline is that creating a pull request will trigger a few separate Github actions worfklows. These will run different validations, check the cost implications and make sure that they follow the set policies. If each of these tests pass, it is possible to move on to the running 'Terraform apply'. This will be done with a separate dispatch step, which means that it needs to be done manually via the Github actions console. This is the easiest way to make sure that there is a human intervention before deployment. Similarly running 'terraform destroy' would need to be triggered manually. 

The way that pipeline is designed means that the infrastructure is always the 'source of truth'. Main branch could be behind as merging the feature branch to the main branch would happen only after successfull infrastructure deployment. 

## Pre-commit hooks

The purpose of pre-commit hooks is to check your code before you are able to commit it. In this pipeline I create a 
pre-commit hook that runs 'terraform fmt' in order to make sure that the code is correctly formatted.

## Backend resources

The backend resources are stored in AWS S3 bucket and DynamoDB. The state file itself is stored in the S3 bucket, whereas DynamoDB contains one table with only one item that would be the lock in case a workflow is currently doing updates to the state file. This is to make sure that two resources are not able to update the state file at the same time, which would lead to conflicts. These resources are created with Cloudformation.

## OICD-role

OICD-role is the role that your actions workflow will assume to get access to your AWS account. This is a very secure way of creating access as it will create temporary credentials that are destroyed as soons as the workflow finishes executing.

## Plan -workflow

The plan workflow runs again 'Terraform fmt' in order to make sure that it is done, in case you would have some contributors that are not running it in the pre-commit hook.

