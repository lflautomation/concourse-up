#!/bin/bash

set -eu

build_dir=$PWD/build
mkdir -p build_dir

version=$(cat version/version)
pushd compilation-vars
  concourse_stemcell_url=$(jq -r .concourse_stemcell_url compilation-vars.json)
  concourse_stemcell_sha1=$(jq -r .concourse_stemcell_sha1 compilation-vars.json)
  concourse_stemcell_version=$(jq -r .concourse_stemcell_version compilation-vars.json)
  director_stemcell_url=$(jq -r .director_stemcell_url compilation-vars.json)
  director_stemcell_sha1=$(jq -r .director_stemcell_sha1 compilation-vars.json)
  director_stemcell_version=$(jq -r .director_stemcell_version compilation-vars.json)
  director_bosh_release_url=$(jq -r .director_bosh_release_url compilation-vars.json)
  director_bosh_release_sha1=$(jq -r .director_bosh_release_sha1 compilation-vars.json)
  director_bosh_release_version=$(jq -r .director_bosh_release_version compilation-vars.json)
  director_bosh_cpi_release_url=$(jq -r .director_bosh_cpi_release_url compilation-vars.json)
  director_bosh_cpi_release_sha1=$(jq -r .director_bosh_cpi_release_sha1 compilation-vars.json)
  director_bosh_cpi_release_version=$(jq -r .director_bosh_cpi_release_version compilation-vars.json)
  concourse_release_url=$(jq -r .concourse_release_url compilation-vars.json)
  concourse_release_version=$(jq -r .concourse_release_version compilation-vars.json)
  concourse_release_sha1=$(jq -r .concourse_release_sha1 compilation-vars.json)
  garden_release_url=$(jq -r .garden_release_url compilation-vars.json)
  garden_release_version=$(jq -r .garden_release_version compilation-vars.json)
  garden_release_sha1=$(jq -r .garden_release_sha1 compilation-vars.json)
popd

mkdir -p "$GOPATH/src/github.com/EngineerBetter/concourse-up"
mv concourse-up/* "$GOPATH/src/github.com/EngineerBetter/concourse-up"
cd "$GOPATH/src/github.com/EngineerBetter/concourse-up"

go build -ldflags "
  -X main.ConcourseUpVersion=$version
  -X github.com/EngineerBetter/concourse-up/bosh.ConcourseStemcellURL=$concourse_stemcell_url
  -X github.com/EngineerBetter/concourse-up/bosh.ConcourseStemcellVersion=$concourse_stemcell_version
  -X github.com/EngineerBetter/concourse-up/bosh.ConcourseStemcellSHA1=$concourse_stemcell_sha1
  -X github.com/EngineerBetter/concourse-up/bosh.ConcourseReleaseURL=$concourse_release_url
  -X github.com/EngineerBetter/concourse-up/bosh.ConcourseReleaseVersion=$concourse_release_version
  -X github.com/EngineerBetter/concourse-up/bosh.ConcourseReleaseSHA1=$concourse_release_sha1
  -X github.com/EngineerBetter/concourse-up/bosh.GardenReleaseURL=$garden_release_url
  -X github.com/EngineerBetter/concourse-up/bosh.GardenReleaseVersion=$garden_release_version
  -X github.com/EngineerBetter/concourse-up/bosh.GardenReleaseSHA1=$garden_release_sha1
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorStemcellURL=$director_stemcell_url
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorStemcellVersion=$director_stemcell_version
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorStemcellSHA1=$director_stemcell_sha1
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorCPIReleaseURL=$director_bosh_cpi_release_url
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorCPIReleaseVersion=$director_bosh_cpi_release_version
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorCPIReleaseSHA1=$director_bosh_cpi_release_sha1
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorReleaseURL=$director_bosh_release_url
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorReleaseVersion=$director_bosh_release_version
  -X github.com/EngineerBetter/concourse-up/bosh.DirectorReleaseSHA1=$director_bosh_release_sha1
" -o "$build_dir/$OUTPUT_FILE"
