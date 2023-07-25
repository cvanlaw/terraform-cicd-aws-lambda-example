terraform {
  cloud {
    organization = "vanlaw_dev"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      name = "terraform_cicd_aws_lambda_example"
    }
  }
}
