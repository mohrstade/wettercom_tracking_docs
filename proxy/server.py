import os

from flask import Flask, Response
from google.cloud import storage

app = Flask(__name__)
client = storage.Client()
BUCKET = os.environ["BUCKET_NAME"]


@app.route("/", defaults={"path": "index.html"})
@app.route("/<path:path>")
def serve(path):
    bucket = client.bucket(BUCKET)
    blob = bucket.blob(path)
    if not blob.exists():
        blob = bucket.blob(path.rstrip("/") + "/index.html")
        if not blob.exists():
            blob = bucket.blob("404.html")
    blob.reload()
    return Response(blob.download_as_bytes(), content_type=blob.content_type)
