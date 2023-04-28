from flask import Blueprint, g, request, current_app
from werkzeug.security import generate_password_hash
from src.http_response import json_response
from src.api.auth import login_required, admin_login_required
from db import get_db, rows_to_dict, row_to_dict
import re

bp = Blueprint("user", __name__, url_prefix="/user")

EMAIL_REGEX = r"^\S+@\S+\.\S+$"
PASSWORD_REGEX = r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$"


@bp.route("/data/", methods=["PUT"])
@login_required
def update_user():
    db = get_db()
    if g.user["google_id"]:
        return json_response("google")

    name = request.json.get("name", "").strip()
    email = request.json.get("email", "").strip()
    password = request.json.get("password", "").strip()

    if name:
        db.execute("UPDATE user set name = ? where id = ?", (name, g.user["id"]))

    if email:
        if re.match(EMAIL_REGEX, email):
            db.execute("UPDATE user set email = ? where id = ?", (email, g.user["id"]))
        else:
            return json_response("bad_request")

    if password:
        if re.match(PASSWORD_REGEX, password):
            db.execute("UPDATE user set password = ? where id = ?", (generate_password_hash(password), g.user["id"]))
        else:
            return json_response("bad_request")

    db.commit()
    return json_response("ok")


@bp.route("/orders/", methods=["GET"])
@login_required
def get_user_orders():
    db = get_db()

    user_orders = rows_to_dict(db.execute("select * from 'order' where user_id = ?", (g.user["id"],)).fetchall(), "user_id")
    for order in user_orders:
        order["created"] = order["created"].strftime('%d.%m.%Y')

    return json_response("ok", data=user_orders)


@bp.route("/", methods=["GET"])
def get_user_info():
    # return nothing or logged user
    message = "user is logged in" if g.user else "nobody logged in"
    json_status = 200 if g.user else 401
    return json_response("ok", data=g.user, message=message, json_status=json_status)


@bp.route("/admin/", methods=["GET"])
@admin_login_required
def get_all_orders():
    db = get_db()

    users = rows_to_dict(db.execute("select * from 'user'").fetchall())
    for user in users:
        user["created"] = user["created"].strftime('%d.%m.%Y %H:%M')

    return json_response("ok", data=users)


@bp.route("/<int:user_id>/admin/", methods=["DELETE"])
@admin_login_required
def delete_user(user_id):
    db = get_db()

    # find all user's orders
    orders = rows_to_dict(db.execute("select id, address_id from 'order' where user_id=?", (user_id, )).fetchall())

    for order in orders:
        # delete all orderFoodLink records
        db.execute("DELETE from orderFoodLink where order_id=?", (order["id"],))
        # delete order with user_id
        db.execute("DELETE from 'order' where id=?", (order["id"],))

        order_same_address = row_to_dict(db.execute("select * from 'order' where address_id=?", (order["address_id"],)).fetchone())
        if not order_same_address:  # address of deleted order is not in use by any another order => delete
            db.execute("DELETE from address where id=?", (order["address_id"],))

    # finally delete user record
    db.execute("DELETE from user where id=?", (user_id,))

    # commit changes
    db.commit()
    return json_response("ok")
