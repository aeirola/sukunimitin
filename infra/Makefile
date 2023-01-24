.PHONY: all init plan apply

all: plan

init:
	@ op run --env-file=.env -- terraform init

plan:
	@ op run --env-file=.env -- terraform plan

apply:
	@ op run --env-file=.env -- terraform apply
