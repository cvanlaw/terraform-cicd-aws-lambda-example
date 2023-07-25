lambda_src_dir := "lambda"
infra_src_dir := "infra/src"
aws_profile := "vanlawdev"

clean_lambda:
  @echo Cleaning Lambda...
  rm -rf {{lambda_src_dir}}/node_modules
  rm -rf {{lambda_src_dir}}/dist

clean_terraform:
  @echo Cleaning Terraform...
  rm -rf {{infra_src_dir}}/.terraform
  rm -f {{infra_src_dir}}/*.zip
  rm -f {{infra_src_dir}}/tfplan

build: clean_lambda
  #!/usr/bin/env bash
  set -euxo pipefail
  echo Building...
  cd {{lambda_src_dir}}
  npm install
  npm run compile

terraform_pre: clean_terraform
  #!/usr/bin/env bash
  set -euxo pipefail
  export AWS_PROFILE={{aws_profile}}
  cd {{infra_src_dir}}
  terraform init -backend=true

plan: build terraform_pre
  #!/usr/bin/env bash
  set -euxo pipefail
  export AWS_PROFILE={{aws_profile}}
  cd {{infra_src_dir}}
  terraform plan -out=tfplan

apply: plan
  #!/usr/bin/env bash
  set -euxo pipefail
  export AWS_PROFILE={{aws_profile}}
  cd {{infra_src_dir}}
  terraform apply tfplan

destroy: terraform_pre
  #!/usr/bin/env bash
  set -euxo pipefail
  export AWS_PROFILE={{aws_profile}}
  cd {{infra_src_dir}}
  terraform destroy -auto-approve

build-and-deploy: build apply
