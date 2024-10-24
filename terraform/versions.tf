terraform {
  backend "s3" {
    bucket         = "mariberg-gitops-tf-backend"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "GitopsTerraformLocks"
  }
}