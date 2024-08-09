from flask import Flask

app = Flask(import_name=__name__)


@app.get(rule='/')
def hello_world():
    return 'Hello Docker!\n'


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)