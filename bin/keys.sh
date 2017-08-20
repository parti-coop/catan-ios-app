#!/bin/sh
set -e

if [ $# -eq 0 ]
  then
    echo "Usage : $0 [development|production]"
    exit
fi

environment_name=$1

. bin/parse_yaml.sh

eval $(parse_yaml ./env.yml "CATAN_CONFIG_")

prefix="CATAN_CONFIG_${environment_name}_"
env_list=$(set | awk -F "=" '{print $1}' | grep "^${prefix}.*")
while IFS= read -r line
do
  echo "${line#$prefix} ==> ${!line}"
  eval "bundle exec pod keys set ${line#$prefix} ${!line}"
done <<< "$env_list"

bundle exec pod keys generate
