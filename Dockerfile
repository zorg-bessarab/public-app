FROM alpine:3.15

RUN apk add --no-cache python3 && apk add --no-cache py-pip

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY flask-app.py ./

ADD https://get.aquasec.com/6.5.0/microscanner /
RUN chmod +x /microscanner
RUN /microscanner [-c -n]  && rm /microscanner

EXPOSE 5000

ENTRYPOINT [ "python3", "./flask-app.py" ]
