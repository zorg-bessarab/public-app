FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY flask-app.py ./
EXPOSE 80

ADD https://get.aquasec.com/5.0.0/microscanner /
RUN chmod +x /microscanner
RUN /microscanner && rm /microscanner

CMD [ "python", "./flask-app.py" ]