from flask import Blueprint, g, request
from src.http_response import json_response
from db import get_db, rows_to_dict

bp = Blueprint("food", __name__, url_prefix="/food")


@bp.route("/", methods=["GET"])
def get_food():
    db = get_db()
    food = db.execute("SELECT * FROM food WHERE is_public = 'true'").fetchall()
    print(rows_to_dict(food))

    return json_response("ok", data=rows_to_dict(food))
