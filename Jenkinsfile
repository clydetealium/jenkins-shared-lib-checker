// Add parameters HERE.
List customParameters = []

library(
  identifier: 'jenkins-shared-lib@938d36ebfc1dffc32fb2bb7186e88290755e3f47',
  retriever: modernSCM([
    $class: 'GitSCMSource',
    remote: 'https://github.com/Tealium/jenkins-shared-lib',
    credentialsId: 'github-cicd-bot-teal-token'
  ])
)

pipeline {
  agent {
    kubernetes {
      label 'jenkins-demo'
      containerTemplate {
        name 'bub'
        image 'tealium-docker-virtual-registry.jfrog.io/jenkins-webhooks-container:latest'
        ttyEnabled true
        command 'cat'
      }
    }
  }

  options {
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '15'))
    skipStagesAfterUnstable()
    timeout(time: 1, unit: 'HOURS')
    timestamps()
  }

  // Environment variables within this top-level environment block can be seen across all containers in any stage.
  environment {
    // Common metadata used across every pipeline and many containers and helper scripts.
    ACCOUNT_ID = "${env.ACCOUNT_ID}"
    ACCOUNT_NAME = "${env.ACCOUNT_NAME}"
    AWS_MAX_ATTEMPTS = '20'
    ENVIRONMENT = "${env.ENVIRONMENT}"
    ENVIRONMENT_PREFIX = "${env.ENVIRONMENT_PREFIX ?: ''}"
    ENVIRONMENT_TYPE = "${env.ENVIRONMENT_TYPE}"
    PLATFORM_NAME = "${env.PLATFORM_NAME}"
    PREFIXED_ENVIRONMENT = "${env.ENVIRONMENT_PREFIX ?: ''}${env.ENVIRONMENT}"
    REGION = "${params.REGION_OVERRIDE ?: env.REGION}"

    // Place pipeline-specific variables here.
    COMPONENT = "${env.JOB_NAME}"
  }

  stages {
    stage('Source Version Stuff') {
      steps {
        container('bub') {
          script {
            def sv = sourceVersion(githubOrg: 'clydetealium')
            echo "DEFAULT BRANCH: ${sv.defaultBranch}"
            echo "${this.class}"
            echo "sv.pipeline.class ${sv.pipeline.class}"
          }
        }
      }
    }
  }
}