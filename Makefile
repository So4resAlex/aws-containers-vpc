.PHONY: help, init, plan, apply, destroy, clean, tfdocs

help: 
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//' 
	
.DEFAULT_GOAL := help
##
## ------------------------------------
## Terraform
## ------------------------------------
##

## make init - Terraform init
init: 
	@terraform init -var-file=environment/dev/backend.tfvars

validate:
	@terraform validate 
	@terraform fmt --recursive 

## make plan - Terraform plan
plan:validate
	@terraform plan -var-file=environment/dev/terraform.tfvars

## make apply - Terraform apply
apply:
	@terraform apply --auto-approve -var-file=environment/dev/terraform.tfvars

## make destroy - Terraform destroy
destroy:validate
	terraform destroy --auto-approve -var-file=environment/dev/terraform.tfvars

## make tfdocs - Gerar documentação do Terraform
tfdocs:
	@docker run --rm --volume "$$(pwd):/terraform-docs" -u $$(id -u) quay.io/terraform-docs/terraform-docs:0.18.0 markdown /terraform-docs > docs/tfdoc.md
	
## make clean - remover variáveis de ambiente
clean:
	@rm -rf terraform.* .terraform.* .terraform* plan *-config
## 
## 
## 