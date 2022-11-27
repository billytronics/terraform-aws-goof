#! /bin/bash

snyk iac test storage/main.tf --rules=iac_custom_rules/bundle.tar.gz
