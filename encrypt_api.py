import gnupg
import json
import os

from flask import Flask, request

app = Flask(__name__)


@app.route('/decryptMessage', methods=['POST', ])
def decrypt_message():
    if request.method == 'POST':
        try:
            post_data = request.get_json()
            _passphrase = post_data.get("Passphrase")
            _message = post_data.get("Message")
    
            base_dir = os.path.dirname(os.path.abspath(__file__))
            gpg_dir = os.path.join(base_dir, '.gpg')
            if not os.path.exists(gpg_dir):
                os.makedirs(gpg_dir)
            gpg = gnupg.GPG(gnupghome=gpg_dir)
    
            decr = gpg.decrypt(_message, passphrase=_passphrase)
            print(decr.data)
    
            return app.response_class(
                response=json.dumps({"DecryptedMessage": decr.data.decode("utf-8"),}),
                status=200,
                mimetype='application/json'
            )
        except:
            pass

    return app.response_class(
        response=json.dumps({"Error": "Only Post method allowed",}),
        status=200,
        mimetype='application/json'
    )
