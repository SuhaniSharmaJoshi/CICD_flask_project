from flask import Flask, request, render_template_string
import os
from prometheus_flask_exporter import PrometheusMetrics


app = Flask(__name__)
metrics = PrometheusMetrics(app)

@app.route("/")
def home():
    #get headers sent by nginx
    client_ip = request.headers.get('X-Real-IP','Not set')
    forwarded_for = request.headers.get('X-Forwarded-For','Not set')
    host = request.headers.get('Host', 'Not set')

    with open('index.html') as f:
        template = f.read()
    
    return render_template_string(
        template,
        host=host,
        client_ip=client_ip,
        forwarded_for=forwarded_for
    ) 

@app.route("/health")
def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

