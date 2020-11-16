FROM alpine:3.7

RUN apk add --no-cache python3 && apk add --no-cache py-pip

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY flask-app.py ./

RUN apk add curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy filesystem --exit-code 0  /

EXPOSE 80

CMD [ "python", "./flask-app.py" ]