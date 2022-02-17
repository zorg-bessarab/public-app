import os
from flask import Flask

app = Flask(__name__)


secret = os.environ['AQUA_TEST']


@app.route(f'/{secret}')
def secret():
    return f'Secret is: {secret}'


@app.route('/')
def index():
    return f'<h1>Hello from Test Secrer</h1>'


if __name__ == "__main__":
    app.run()
