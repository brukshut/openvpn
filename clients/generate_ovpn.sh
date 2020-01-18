#!/bin/bash

##
## openvpn
## generate_ovpn.sh
##

## functions

function die { printf "%s\n" "$*" 1>&2 && exit 1; }

## generate client config
function generate_client_config {
  ## pass client name as argument
  local client_dir=$1
  local client=$2
  [[ -d ${client_dir} ]] || die "${client_dir} not found"

  ## ensure directories exist
  local files=${client_dir}/files
  local base=${client_dir}/base
  local configs=${client_dir}/configs
  for dir in $files $base $config; do
    [[ -d ${dir} ]] || die "${dir} not found"
  done
  ## ensure files exist
  local client_crt=${files}/${client}.crt
  local client_key=${files}/${client}.key
  local base_conf=${configs}/client.conf
  local ca_file=${base}/ca.crt
  local ta_file=${base}/ta.key
  for file in $client_crt $client_key $base_conf $ca_file $ta_file; do
    [[ -e ${file} ]] || die "${file} not found"
  done
  ## generate ovpn file
  cat ${base_conf} > ${configs}/${client}.ovpn
  local pattern="%s\n%s\n%s\n"
  printf ${pattern} '<key>' "$(cat ${client_key})" '</key>' >> ${configs}/${client}.ovpn
  printf ${pattern} '<cert>' "$(cat ${client_crt})" '</cert>' >> ${configs}/${client}.ovpn
  printf ${pattern} '<ca>' "$(cat ${ca_file})" '</ca>' >> ${configs}/${client}.ovpn
  printf ${pattern} '<tls-auth>' "$(cat ${ta_file})" '</tls-auth>' >> ${configs}/${client}.ovpn
  printf "%s\n" "${configs}/${client}.ovpn"
}

## end functions

## main

generate_client_config . damascus

## end main

