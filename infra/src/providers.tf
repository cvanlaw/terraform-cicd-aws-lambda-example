provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Owner      = "cvanlaw/terraform-cicd-aws-lambda-example"
      Repository = "https://github.com/cvanlaw/terraform-cicd-aws-lambda-example"
    }
  }
}
