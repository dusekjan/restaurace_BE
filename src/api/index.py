from flask import Blueprint, render_template, current_app, request
from src.api.auth import admin_login_required
from src.http_response import json_response

bp = Blueprint('index', __name__)


@bp.route('/', defaults={"path": ""})
@bp.route('/<path:path>')
def serve_index_page(path):
    return render_template("index.html")



@bp.route('/restaurant-opened', methods=["GET"])
def is_restaurant_opened():
    return json_response("ok", data={"opened": current_app.config["RESTAURANT_OPENED"]})


@bp.route('/restaurant-opened', methods=["PUT"])
@admin_login_required
def open_or_close_restaurant():
    if type(request.json["opened"]) is bool:
        current_app.config["RESTAURANT_OPENED"] = request.json["opened"]
        return json_response("ok")
    else:
        return json_response("bad_request")


"""
Simple requests, meanwhile, like a POST request from a browser-based form submission, 
don't trigger a preflight request, so the CORS policy doesn't matter.

So, if you do have a JSON API, limiting the allowed origins or eliminating CORS altogether 
is a great way to prevent unwanted requests. You don't need to use CSRF tokens in that situation. 
If you have a more open CORS policy with regard to origins, it's a good idea to use CSRF tokens.
"""


@bp.after_app_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type, Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE, OPTIONS')

    if current_app.config["DEBUG"]:
        response.headers.add('Access-Control-Allow-Origin', 'http://localhost:3000')
        response.headers.add('Access-Control-Allow-Credentials', 'true')
    return response
