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
```
snyk iac test storage/main.tf
snyk iac test tf-plan.json --scan=planned-values

Test Summary

  Organization: billys-sandbox
  Project name: storage

✔ Files without issues: 0
✗ Files with issues: 1
  Ignored issues: 0
  Total issues: 6 [ 0 critical, 2 high, 1 medium, 3 low ]
```

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
snyk iac describe --service="aws_s3" --drift

Scanned states (1)
Scan duration: 2s
Provider version used to scan: 4.41.0. Use --tf-provider-version to use another version.
Snyk Scanning Infrastructure As Code Discrepancies...

  Info:    Resources under IaC, but different to terraform states.
  Resolve: Reapply IaC resources or update into terraform.

Changed resources: 1

State: tfstate://terraform.tfstate [ Changed Resources: 1 ]

  Resource Type: aws_s3_bucket
    ID: by-terraform-s3-goof-bucket
    + grant.0: null => {"id":"","permissions":["READ","WRITE"],"type":"Group","uri":"http://acs.amazonaws.com/groups/global/AllUsers"}
    + tags: null => {"owner":"by"}
    + timeouts: null => {}

Test Summary

  Managed Resources: 1
  Changed Resources: 1

  IaC Coverage: 100%
  Info: To reach full coverage, remove resources or move it to Terraform.

  Tip: Run --help to find out about commands and flags.
      Scanned with aws provider version 4.41.0. Use --tf-provider-version to update.
```

you will see that it detects any changes to the managed resources by comparing with the tfstate file.
