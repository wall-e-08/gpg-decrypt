from flask import Flask, request, jsonify
import gnupg

app = Flask(__name__)


@app.route('/', methods=['POST',])
def decryptMessage():
    if request.method == 'POST':
        passphrase = "topsecret"
        
        post_data = request.get_json()
        print(post_data)
        if post_data.get("Message"):
            f = open("encrypted_msg.gpg", "w+")
            f.write(post_data.get("Message"))

        gpg = gnupg.GPG(gnupghome='/home/wall-e/tmp-home/.gpg')
        # gpg.encoding = 'utf-8'
        input_data = gpg.gen_key_input(
            key_type="RSA", key_length=1024,
            passphrase=passphrase,
        )
        # print("input data: {}\n".format(input_data))
        key = gpg.gen_key(input_data)

        # create ascii-readable versions of pub / private keys
        ascii_armored_public_keys = gpg.export_keys(key.fingerprint)
        ascii_armored_private_keys = gpg.export_keys(
            keyids=key.fingerprint,
            secret=True,
            passphrase=passphrase,
        )
        
        # export
        with open('key.asc', 'w') as f:
            f.write(ascii_armored_public_keys)
            f.write(ascii_armored_private_keys)

        with open('encrypted_msg.gpg', 'rb') as f:
            status = gpg.decrypt_file(
                file=f,
                passphrase=passphrase,
                output='decrypted.txt',
            )
        
        print("RESULT:: {}\n".format(status))
        print("data: {}\n".format(status.data))
        print("username: {}\n".format(status.username))

        print("ok: {}\n".format(status.ok))
        print("status: {}\n".format(status.status))
        print("stderr: {}\n".format(status.stderr))

        # return key
    return 'Hello, omg'
