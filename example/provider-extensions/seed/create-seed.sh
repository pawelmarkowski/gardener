#!/usr/bin/env bash
#
# Copyright (c) 2022 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, v. 2 except as noted otherwise in the LICENSE file
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses~LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

usage() {
  echo "Usage:"
  echo "> create-seed.sh [ -h | <garden-kubeconfig> <seed-kubeconfig> ]"
  echo
  echo ">> For example: create-seed.sh ~/.kube/garden-kubeconfig.yaml ~/.kube/kubeconfig.yaml"

  exit 0
}

if [ "$1" == "-h" ] || [ "$#" -ne 2 ]; then
  usage
fi

garden_kubeconfig=$1
seed_kubeconfig=$2

registry_domain=$(cat "$SCRIPT_DIR"/registrydomain)

echo "Skaffolding seed"
GARDENER_LOCAL_KUBECONFIG=$garden_kubeconfig \
  SKAFFOLD_DEFAULT_REPO=$registry_domain \
  REGISTRY_DOMAIN=$registry_domain \
  SKAFFOLD_PUSH=true \
  skaffold run -m gardenlet -p extensions --kubeconfig="$seed_kubeconfig"
