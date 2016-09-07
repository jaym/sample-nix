from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"


@app.route("/world")
def world():
    return 1/0

def main():
    app.run()
