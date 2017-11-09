pipeline {
  agent {
    label "docker"
  }
  parameters {
    string(name: "CELL_NUMBER", defaultValue: "1", description: "Integration. Number of cells to deploy")
    booleanParam(name: "SKIP_INTEGRATION", defaultValue: false, description: "Whether integration should be skipped")
  }
  stages {
    stage("Retrieve build environment") {
      steps {
        script {
          GIT_COMMIT_MESSAGE = sh(returnStdout: true, script: "git rev-list --format=%B --max-count=1 ${GIT_COMMIT}").trim()
        }
      }
    }
    stage("Build image") {
      steps {
        script {
          docker.build("smartbox/brain:${GIT_COMMIT}")
        }
      }
    }
    stage("Analyze image") {
      parallel {
        stage("Style analysis") {
          steps {
            sh("docker run --rm smartbox/brain:${GIT_COMMIT} bundle exec rubocop --no-color -D")
          }
        }
        stage("Security analysis") {
          steps {
            sh("docker run --rm smartbox/brain:${GIT_COMMIT} bundle exec brakeman --no-color -zA")
          }
        }
        stage("Model specs") {
          steps {
            sh("docker run --rm -e COVERAGE=models -t smartbox/brain:${GIT_COMMIT} bundle exec rspec --no-color spec/models")
          }
        }
        stage("Request specs") {
          steps {
            sh("docker run --rm -e COVERAGE=requests -t smartbox/brain:${GIT_COMMIT} bundle exec rspec --no-color spec/requests")
          }
        }
        stage("Library specs") {
          steps {
            sh("docker run --rm -e COVERAGE=lib -t smartbox/brain:${GIT_COMMIT} bundle exec rspec --no-color spec/lib")
          }
        }
        stage("All specs") {
          steps {
            sh("docker run --rm -t smartbox/brain:${GIT_COMMIT} bundle exec rspec --no-color")
          }
        }
      }
    }
    stage ("Build production image") {
      steps {
        script {
          docker.build("smartbox/brain:${GIT_COMMIT}-production", "-f Dockerfile.production .")
        }
      }
    }
    stage ("Publish production image (internal)") {
      steps {
        script {
          docker.withRegistry("https://registry.smartbox.io/") {
            docker.image("smartbox/brain:${GIT_COMMIT}-production").push(GIT_COMMIT)
          }
        }
      }
    }
    stage("Run integration tests") {
      when { expression { !SKIP_INTEGRATION } }
      steps {
        script {
          build job: "integration/master", parameters: [
            text(name: "COMMIT_MESSAGE", value: GIT_COMMIT_MESSAGE),
            string(name: "BRAIN_COMMIT", value: GIT_COMMIT),
            string(name: "CELL_NUMBER", value: CELL_NUMBER)
          ]
        }
      }
    }
    stage("Publish production image (public)") {
      when { expression { !SKIP_INTEGRATION } }
      steps {
        script {
          docker.withRegistry("https://registry.hub.docker.com", "docker-hub-credentials") {
            docker.image("smartbox/brain:${GIT_COMMIT}-production").push("latest")
          }
        }
      }
    }
  }
}
