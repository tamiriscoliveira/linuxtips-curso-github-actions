#!/usr/bin/env bash
set -euo pipefail

: "${TERRAFORM_VERSION:?TERRAFORM_VERSION não definido (configure a variable TERRAFORM_VERSION no repositório)}"
: "${GITHUB_OUTPUT:?GITHUB_OUTPUT não definido; este script deve ser executado dentro do GitHub Actions}"

## CONFIGURAÇÃO DO TERRAFORM
DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

echo "Instalando Terraform ${TERRAFORM_VERSION}..."
mkdir -p "$HOME/bin"

if ! curl -sfL "$DOWNLOAD_URL" -o /tmp/terraform.zip; then
  echo "::error::Falha ao baixar o Terraform ${TERRAFORM_VERSION} de ${DOWNLOAD_URL}"
  exit 1
fi

if ! unzip -q -o /tmp/terraform.zip -d "$HOME/bin"; then
  echo "::error::Falha ao extrair o binário do Terraform"
  exit 1
fi
export PATH="$HOME/bin:$PATH"

##########

cd ./iac/

echo "::group::Terraform initialization"
if ! terraform init -backend=false; then
  echo "::error::Falha no 'terraform init'"
  echo "tf_result=failure" >> "$GITHUB_OUTPUT"
  echo "::endgroup::"
  exit 1
fi
echo "::endgroup::"

echo "::add-mask::${AWS_ACCESS_KEY_ID:-LINUXTIPSTRIGUSGIRUS}"

if terraform validate -no-color; then
  echo "::notice::Terraform validation succeeded"
  echo "tf_result=success" >> "$GITHUB_OUTPUT"
else
  echo "::error file=ec2.tf,line=1,col=1::Terraform validation failed"
  echo "tf_result=failure" >> "$GITHUB_OUTPUT"
  exit 1
fi

echo "::warning::Remember to run 'terraform fmt -check' in a separate step."