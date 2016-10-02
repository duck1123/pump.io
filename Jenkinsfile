#!groovy

def org = 'duck1123'
def project = 'pump.io'

def repo = 'repo.jiksnu.org/'
def repoCreds = '8bb2c76c-133c-4c19-9df1-20745c31ac38'
def repoPath = 'https://repo.jiksnu.org/'

// Set build properties
properties([[$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', numToKeepStr: '5']],
            [$class: 'GithubProjectProperty', displayName: 'pump.io', projectUrlStr: "https://github.com/${org}/${project}/"]]);

stage('Prepare environment') {
    node {
        step([$class: 'WsCleanup'])

        // env.CXX = "g++-4.8"

        // Set current git commit
        checkout scm

        sh "git rev-parse HEAD | tr -d '\n' | tee git-commit"
        env.GIT_COMMIT = readFile('git-commit').trim()

        sh 'git rev-parse --abbrev-ref HEAD | tee git-branch'
        env.GIT_BRANCH = readFile('git-branch').trim()

        sh 'git branch --contains HEAD -r | tee git-branches'
        def gitBranches = readFile('git-branches').trim().tokenize('\n')

        def isPR = false

        for (branch in gitBranches) {
            if (branch.contains('origin/pr')) {
                isPR = true
                break
            }
        }

        // FIXME: Awaiting JENKINS-26481
        // isPR = gitBranches.any { it.contains('origin/pr') }

        if (env.BRANCH_NAME) {
            env.GIT_BRANCH = env.BRANCH_NAME
        } else if (isPR) {
            def matcher = gitBranches =~ /origin\/pr\/(\d+)\/\*/
            env.PR_NUMBER = matcher[0][1]
            env.GIT_BRANCH = 'PR-' + env.PR_NUMBER
        }

        if (env.GIT_BRANCH == 'develop') {
            env.BRANCH_TAG = 'latest'
        } else if (env.GIT_BRANCH == 'master') {
            // TODO: Parse version numbers
            env.BRANCH_TAG = 'stable'
        } else {
            env.BRANCH_TAG = env.GIT_BRANCH.replaceAll('/', '-')
        }

        // Print Environment
        sh 'env | sort'
    }
}

stage('Build Image') {
    node('docker') {
        checkout scm

        wrap([$class: 'AnsiColorBuildWrapper']) {
            mainImage = docker.build("${org}/${project}:${env.BRANCH_TAG}")

            docker.withRegistry(repoPath, repoCreds) {
                mainImage.push()
            }
        }
    }
}

stage('Unit Tests') {
    node('docker') {
        checkout scm

        mainImage.inside {
            sh 'npm install'
            sh 'npm test'
        }
    }
}
