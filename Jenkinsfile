podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: sonarscanner
    image: openjdk:11
    command: ['cat']
    tty: true
  - name: docker
    image: docker:19.03
    command: ['cat']
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
    - name: docker-cfg
      mountPath: /root/.docker
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
  - name: docker-cfg
    projected:
      sources:
      - secret:
          name: regcred
          items:
            - key: .dockerconfigjson
              path: config.json
"""
  )
{
node (POD_LABEL) {
  stage('SCM') {
    git branch: 'trivy', url: 'https://github.com/ZotakBmm/public-app'
  }
  stage('SonarQube analysis') {
    def scannerHome = tool 'jenkins-scanner';
    container('sonarscanner'){
     withSonarQubeEnv(credentialsId: 'sonar-server') {
     sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=python-flask-public-app -Dsonar.language=py -Dsonar.sources=. -Dsonar.host.url=http://10.96.27.12:9000 -Dsonar.login=7c179c83131e639089208682c3c420664f1b7193"
     }     
     }
}
  stage('Aqua Docker Scan') {
    container('docker') {
    sh 'docker build . -t mbessarab/publicapp && docker push mbessarab/publicapp'
      }
  }
  stage('Audit deployment yamls kubesec.io'){
      container('docker'){
        step('test deployment config'){
        sh 'docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < flask-app-deployment.yaml'
      }
      }
      container('docker'){
      step('test service config'){
        sh 'docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < flask-app-service.yaml'
      }
      }
  }
  stage('Deploy to test namespace') {
      
  }
}
}