from app import app, functions
from flask import Flask, jsonify, request

# def multiple(num):
#   return num * num
  
@app.route('/hello', methods=['GET'])
def helloworld():
    if(request.method == 'GET'):
        data = {"data": "Hello World"}
        return jsonify(data)
  
  
@app.route('/calculate', methods=['GET'])
def calculate():
    if(request.method == 'GET'):
        number = request.args.get('number')
        result = ''
        if number.isnumeric():
            result = functions.multiple(int(number))
        else:
            result = 'Provide good inputs'
        data = {"data": result}
        return jsonify(data)