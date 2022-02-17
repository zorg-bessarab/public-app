chuckNorris()
podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kubectl
    image: mbessarab/kubectl:latest
    command: ['cat']
    tty: true
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
  stage('Aqua Docker Scan') {
    container('docker') {
        sh 'docker build . -t mbessarab/publicapp && docker push mbessarab/publicapp'
      }
  }
  stage('Audit deployment yamls kubesec.io'){
      container('docker'){
        sh 'docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < flask-app-deployment.yaml'
      }
      }
  stage('Scan Image') {
      container('docker') {
        aqua customFlags: '', hideBase: false, hostedImage: 'mbessarab/publicapp:latest', localImage: '', locationType: 'hosted', notCompliesCmd: '', onDisallowed: 'ignore', policies: '', register: false, registry: 'Docker Hub', showNegligible: false
      }
    }
  stage('Deploy to test namespace') {
    container('kubectl'){
       kubernetesDeploy configs: 'flask-app-deployment.yaml, flask-app-service.yaml', kubeConfig: [path: ''], kubeconfigId: 'minikube-admin', secretName: '', ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
    }
}
}
}
