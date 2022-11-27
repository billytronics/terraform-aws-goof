# Snyk IaC Demo

* IaC Custom rules
* Snyk IaC scan of Terraform code (static) and Terraform plan
* Drift detection

This repository contains:
* storage - Terraform code to spin up AWS S3 Bucket
* storage-tagged - Terraform code to spin up AWS S3 Bucket with resource tagging 
* compute - Terraform code to spin up an AWS EC2 instance (this is to show that Snyk IaC can scan multiple envs)
* iac_custom_rules - Contains custom rules bundle with Rego rules

## Demo #1 - Scanning of Terraform code (static) and Terraform plan

## Demo #2 - Custom Rules

iac_custom_rules contains a custom rule which requires users to tag the resource that they are provisioning.

Scanning of storage/main.tf against the custom rule would flag out the following issue:
```
  [Medium] Missing an owner from tag
  Rule:    custom rule MY_RULE_1
  Path:    input > resource > aws_s3_bucket[by-s3-bucket] > tags
  File:    storage/main.tf
```

## Demo #3 - Drift detection
1. Provision the AWS S3 Bucket service in storage. Note that my region is in 'ap-southeast-1'.

2. Head over to your AWS console and add a new tag to the by-terraform-s3-goof-bucket e.g owner=by

3. Run the following command to detect the drift in configurations:

```
snyk iac describe --only-managed
```

you will see that it detects any changes to the managed resources by comparing with the tfstate file.
