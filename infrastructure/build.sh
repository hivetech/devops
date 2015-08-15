#!/usr/bin/env bash

# NOTE EXPERIMENTAL - move it to the script directory

requirements() {
  # TODO check terraform is installed
  # TODO check TF_VAR_do_token is set
  # TODO export .env vars toward terraform TF_VAR_{key} format
  # TODO make it coherent with expected config values
  [[ -f "${TF_VAR_key_file}" ]] || ssh-keygen -t rsa
}

check_requirements
terraform apply
