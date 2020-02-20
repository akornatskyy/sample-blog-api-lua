#!/bin/bash
set -eo pipefail


cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

modules=( */ )
for module in "${modules[@]%/}" ; do
  image=akorn/sample-blog-api-lua:${module}
  echo building $image ...
  docker build -q -t ${image} -f ${module}/Dockerfile .
  docker run --rm ${image} nginx -v
done
