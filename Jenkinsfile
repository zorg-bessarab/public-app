podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
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
  ) {

  def image = "jenkins/jnlp-slave"
  node(POD_LABEL) {
    stage('Build Docker image') {
      git branch: 'trivy', url: 'https://github.com/ZotakBmm/public-app'
      container('docker') {
          sh 'docker build . -t mbessarab/publicapp && docker push mbessarab/publicapp'
      }
    }
  }
}