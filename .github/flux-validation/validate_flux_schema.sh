#!/bin/bash

set -o pipefail
# exit_status=0

echo "INFO - Downloading Flux OpenAPI schemas"
mkdir -p /tmp/flux-crd-schemas/master-standalone-strict

curl -sL https://github.com/fluxcd/flux2/releases/latest/download/crd-schemas.tar.gz | tar zxf - -C /tmp/flux-crd-schemas/master-standalone-strict

echo "START - Validating clusters"
find ./clusters -maxdepth 15 -type f -name '*.yaml' -print0 | while IFS= read -r -d $'\0' file; do

  echo "INFO - Validating Cluster File - ${file}"

  kubeval ${file} --strict --ignore-missing-schemas --additional-schema-locations=file:///tmp/flux-crd-schemas

  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    exit_status=1
  fi
done

echo "END - Validated clusters Successfully"

# mirror kustomize-controller build options
kustomize_flags="--load-restrictor=LoadRestrictionsNone --reorder=legacy"
kustomize_config="kustomization.yaml"

echo "START - Validating kustomize overlays"
find . -type f -name $kustomize_config -print0 | while IFS= read -r -d $'\0' file; do
  echo "INFO - Validating kustomization ${file/%$kustomize_config/}"

  kustomize build "${file/%$kustomize_config/}" $kustomize_flags |
    kubeval --ignore-missing-schemas --strict --additional-schema-locations=file:///tmp/flux-crd-schemas --ignored-path-patterns "^.charts/kubeform/templates/"

  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    exit_status=1
  fi
done
echo "END - Validated Kustomize Overlays Successfully"
