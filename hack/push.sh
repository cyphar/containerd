#!/bin/bash

# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

source $(dirname "${BASH_SOURCE[0]}")/test-utils.sh

DEPLOY_BUCKET=${DEPLOY_BUCKET:-"cri-containerd-staging"}
BUILD_DIR=${BUILD_DIR:-"_output"}
TARBALL=${TARBALL:-"cri-containerd.tar.gz"}

release_tar=${ROOT}/${BUILD_DIR}/${TARBALL}
if [ ! -e ${release_tar} ]; then
  echo "Release tarball is not built"
  exit 1
fi

if ! gsutil ls "gs://${DEPLOY_BUCKET}" > /dev/null; then
  create_ttl_bucket ${DEPLOY_BUCKET}
fi

# TODO(random-liu): Add checksum for the tarball.
gsutil cp ${release_tar} "gs://${DEPLOY_BUCKET}/"
echo "Release tarball is uploaded to:
  https://storage.googleapis.com/${DEPLOY_BUCKET}/${TARBALL}"
