FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY flask-app.py ./

EXPOSE 80

CMD [ "python", "./flask-app.py" ]