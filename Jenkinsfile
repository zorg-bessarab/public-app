podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:19.03
    command: ['cat']
    env:
    - name: AQUA_SERVER_URL
      value: http://192.168.49.2:31876
    - name: AQUA_USERNAME
      value: administrator
    - name: AQUA_PASSWORD
      value: Passw0rd
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
"""
  ) {

  def image = "jenkins/jnlp-slave"
  node(POD_LABEL) {
    stage('Build Docker image') {
      git 'https://github.com/ZotakBmm/public-app'
      container('docker') {
          sh 'docker build . -t mbessarab/publicapp && docker push mbessarab/publicapp'
      }
    }
  }
}