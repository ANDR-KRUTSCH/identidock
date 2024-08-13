import hashlib
import html

import requests
import redis

from flask import Flask, Response, request


app = Flask(import_name=__name__)
cache = redis.Redis(host='redis', port=6379, db=0)


default_name = 'Joe Bloggs'
salt = 'UNIQUE_SALT'


@app.route(rule='/', methods=['GET', 'POST'])
def mainpage():
    name = default_name
    
    if request.method == 'POST':
        name = html.escape(s=request.form['name'], quote=True)
        print(1)
    
    salted_name: str = salt + name
    name_hash = hashlib.sha256(string=salted_name.encode()).hexdigest()
    
    header = '<html><head><title>Identidock</title></head>'
    body = '<body><form method="POST"><p>Hello <input type="text" name="name" value="{0}"></p><p><input type="submit" value="submit"></p></form><p>You look like a: <img src="/monster/{1}"></p>'.format(name, name_hash)
    footer = '</body></html>'

    return header + body + footer

@app.route(rule='/monster/<name>')
def get_identicon(name):
    name = html.escape(s=name, quote=True)

    image = cache.get(name=name)

    if image is None:
        print('Cache miss', flush=True)

        response = requests.get(url='http://dnmonster:8080/monster/' + name + '?size=80')
        image = response.content

        cache.set(name=name, value=image)

    return Response(response=image, mimetype='image/png')


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)