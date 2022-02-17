FROM alpine:3.15

RUN apk add --no-cache python3 && apk add --no-cache py-pip

ENV AQUA_SERVER_URL=https://10.108.37.24
ENV AQUA_USERNAME=jenkins
ENV AQUA_PASSWORD=jenkin$CI1

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY flask-app.py ./

ADD https://get.aquasec.com/6.5.0/microscanner /
RUN chmod +x /microscanner
RUN /microscanner [--continue-on-failure --no-verify]  && rm /microscanner

EXPOSE 5000

ENTRYPOINT [ "python3", "./flask-app.py" ]
