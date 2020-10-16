FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY flask-app.py ./
EXPOSE 5000

CMD [ "python", "./flask-app.py" ]