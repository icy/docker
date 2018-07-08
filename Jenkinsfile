#!/usr/bin/env groovy

// Author : Ky-Anh Huynh
// Date   : 2018 July 08
// License: MIT

@Library("icy@master")

def icyUtils = new org.icy.Utils()

try {
  node {
    checkOut("clean")

    stage("bocker-compiling") {
      sh '''
        make all
      '''
    }

    stage("docker-build-demo-proxy") {
      sh """#!/usr/bin/env bash
        cd context/ \
        && docker build -t "icy-demo-proxy:${env.BUILD_NUMBER}" . \
        || exit

        docker images | grep demo-proxy
      """
    }
  }
}
catch (exc) {
  currentBuild.result = currentBuild.result ?: "FAILED"
  echo "Caught: ${exc}"
  throw exc
}
finally {
  echo "Finally."
}
