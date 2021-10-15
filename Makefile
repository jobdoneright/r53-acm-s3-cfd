TERRAFORM_REQUIRED_VERSION := 1.0.9
TERRAFORM_INSTALLED_VERSION := $(shell terraform version 2>/dev/null | perl -n -e 'print $$1 if /Terraform v(\d+.\d+.\d+)/')

all: validate docs

tfenv:
	if [ "${TERRAFORM_REQUIRED_VERSION}" != "${TERRAFORM_INSTALLED_VERSION}" ] && command -v tfenv > /dev/null ; then tfenv install ${TERRAFORM_REQUIRED_VERSION} && tfenv use ${TERRAFORM_REQUIRED_VERSION}; fi


all: validate docs

validate: tfenv
	terraform init --upgrade
	terraform fmt
	terraform validate

version_check:
	echo ${TERRAFORM_INSTALLED_VERSION}

docs:
	docker run --rm -v ${PWD}:/data \
  	cytopia/terraform-docs terraform-docs-replace-012 --sort-by required markdown README.md

entr:
	find . -name '*.tf' -o -name '*.tfvars' -o -name '*.hcl' -o -name '*.md' | entr -c make

clean:
	rm -rf .terraform.lock.hcl .terraform

install_tools_macos:
	brew install entr
	brew install tfenv
