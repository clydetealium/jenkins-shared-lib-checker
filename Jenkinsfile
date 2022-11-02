
def lib = library(
  identifier: 'jenkins-shared-lib@SUP-1915_jp_lambda_update_issues',
  retriever: modernSCM([
    $class: 'GitSCMSource',
    remote: 'https://github.com/Tealium/jenkins-shared-lib',
    credentialsId: 'github-cicd-bot-teal-token'
  ])
)

def lambdaUpdate = lib.com.tealium.jp.LambdaUpdate.new(this)

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

  stages {
    stage('lambda update PoC') {
      steps {
        container('bub') {
          script {
            def lambdaUpdate2 = lib.com.tealium.jp.LambdaUpdate.new(this)
            def simpleShell = lib.com.tealium.SimpleShell.new(this)
            
            lambdaUpdate2.messagePlease('This is a message!')
            simpleShell.execute("""
              echo 'simpleShell type: ${simpleShell.class}'
              echo 'simpleShell id": ${simpleShell.hashCode()}'
            """)
            
            lambdaUpdate2.messagePlease("""
              This is a message!
              lambdaUpdate2 type: ${lambdaUpdate2.class}
              lambdaUpdate2 id: ${lambdaUpdate2.hashCode()}
            """)
            
            lambdaUpdate.messagePlease("""
              This is a message!
              lambdaUpdate type: ${lambdaUpdate.class}
              lambdaUpdate id: ${lambdaUpdate2.hashCode()}
              equality check: ${lambdaUpdate == lambdaUpdate2}
            """)
          }
        }
      }
    }
  }
}
