import os
from flask import Flask, request, jsonify
from flask_cors import cross_origin

app = Flask(__name__)

@app.route('/validate', methods=['POST'])
@cross_origin()
def validate_input():
    try:
        data = request.get_json()
        input_value = data.get('input')

        # Perform your validation logic here
        # For example, you can check if the input is an even number
        is_valid = int(input_value) % 2 == 0

        return jsonify({'isValid': is_valid})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(port=os.environ.get("PORT", 5000), host="0.0.0.0")
