#!/usr/bin/env bash

role_arn="arn:aws:iam::675101987453:role/arbit_role"

# This script assumes a configured AWS CLI and that the role_arn above is set.
# (1) Create lambda functions for the downloader
# (2) Download old data
# (3) Setup jobs to download new nightly data

rm main.zip
zip -r main.zip *.py

aws lambda delete-function \
  --function-name edgar-download-day

aws lambda create-function \
  --function-name edgar-download-day \
  --runtime python3.6 \
  --zip-file fileb://main.zip \
  --handler main.run \
  --role ${role_arn} \
  --timeout 3
