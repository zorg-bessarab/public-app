import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return f'<h1>Hello from Test Secret {os.getenv('AQUA_TEST')}</h1>'
    
if __name__ == "__main__":
    app.run()