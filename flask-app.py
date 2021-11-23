import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    secret = os.getenv('AQUA_TEST')
    return f'<h1>Hello from Test Secret {secret} </h1>'
    
if __name__ == "__main__":
    app.run()