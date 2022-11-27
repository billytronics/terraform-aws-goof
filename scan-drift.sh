#! /bin/bash

snyk iac describe --all --filter=Attr.region==\'ap-southeast-1\' --from="tfstate://storage/terraform.tfstate"
