#!/bin/bash -xe

# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-standalone-strict - de-referenced schemas, more useful as standalone documents, additionalProperties disallowed
#   X.Y.Z-local - relative references, useful to avoid the network dependency

declare -a arr=(
    # Add here the version you want to re-generate
    master
    )

    # This list is used only list of already genrated schema definition
    # (or when we need to rebuild all definitions)
    declare -a arr2=(
    # master
    # v1.18.x
    v1.19.5
)

for version in "${arr[@]}"
do
      schema=https://raw.githubusercontent.com/kubernetes/kubernetes/${version}/api/openapi-spec/swagger.json
      prefix=https://kubernetesjsonschema.dev/${version}/_definitions.json

      openapi2jsonschema -o "${version}-standalone-strict" --expanded --kubernetes --stand-alone --strict "${schema}"
      openapi2jsonschema -o "${version}-standalone-strict" --kubernetes --stand-alone --strict "${schema}"
done
