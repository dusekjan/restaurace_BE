from flask import Blueprint, g, request, current_app
from src.http_response import json_response
from db import get_db, rows_to_dict, row_to_dict
from src.api.auth import login_required, admin_login_required
import datetime

bp = Blueprint("order", __name__, url_prefix="/order")

RESTAURANT_ADDRESS = {"city": "Praha", "street": "V Záhoří 158", "postal_code": "15800"}


@bp.route("/<int:order_id>/", methods=["GET"])
@login_required
def order_with_food(order_id):
    db = get_db()

    # jenom svoje objednavky!
    order_owner = row_to_dict(db.execute("select user_id from 'order' where id = ?", (order_id,)).fetchone())
    if g.user["id"] != order_owner["user_id"]:
        return json_response("forbidden")

    order, food = get_order_and_food(db, order_id)

    order["created"] = order["created"].strftime('%d.%m.%Y %H:%M')
    order["food"] = food

    address = row_to_dict(db.execute("select city, street, postal_code from address where id = ?", (order["address_id"], )).fetchone())
    order["custom_address"] = address != RESTAURANT_ADDRESS

    return json_response("ok", data=order)


@bp.route("/<int:order_id>/admin/", methods=["GET"])
@admin_login_required
def get_admin_order_with_food(order_id):
    db = get_db()

    order, food = get_order_and_food(db, order_id)

    order["created"] = order["created"].strftime('%d.%m.%Y %H:%M')
    order["food"] = food

    address = row_to_dict(db.execute("select city, street, postal_code from address where id = ?", (order["address_id"], )).fetchone())
    order["address"] = address
    order["custom_address"] = address != RESTAURANT_ADDRESS

    user = row_to_dict(db.execute("select email, name from 'user' where id = ?", (order["user_id"], )).fetchone())
    order["user_email"] = user["email"]
    order["user_name"] = user["name"]

    return json_response("ok", data=order)


@bp.route("/admin/", methods=["GET"])
@admin_login_required
def get_all_orders():
    db = get_db()

    orders = rows_to_dict(db.execute("select * from 'order'").fetchall())
    for order in orders:
        order["created"] = order["created"].strftime('%d.%m.%Y')

    return json_response("ok", data=orders)


@bp.route("/<int:order_id>/admin/", methods=["PUT"])
@admin_login_required
def change_order_status(order_id):
    db = get_db()

    status = request.json.get("status", "")
    if status not in ("true", "false", "cancel"):
        return json_response("bad_request")

    db.execute("UPDATE 'order' set is_done = ? where id = ?", (status, order_id))
    db.commit()

    return json_response("ok")


@bp.route("/", methods=["POST"])
@login_required
def make_order():
    if not current_app.config["RESTAURANT_OPENED"]:
        return json_response("closed")

    db = get_db()
    final_price = 0

    request_address = request.json["address"]
    city = str(request_address.get("city", "")).strip().title()
    street = str(request_address.get("street", "")).strip().title()
    postal_code = str(request_address.get("postal", "")).strip().title()
    menu = request.json["menu"]
    if not all((city, street, postal_code, menu)):
        return json_response("bad_request")

    custom_address = {"city": city, "street": street, "postal_code": postal_code} != RESTAURANT_ADDRESS
    if custom_address:
        print("objednávka s dodáním mimo prodejnu", flush=True)
        final_price += 70

    # zkontrolovat existenci adresy
    address = db.execute('SELECT * FROM address WHERE city = ? and street = ? and postal_code = ?',
                         (city, street, postal_code)).fetchone()
    address_id = row_to_dict(address)["id"] if address else None
    if not address_id:
        db.execute("INSERT INTO address (city, street, postal_code)  VALUES (?, ?, ?)",
                   (city, street, postal_code))
        address_id = db.execute("SELECT last_insert_rowid()").lastrowid
        print("vytvářím novou adresu s ID: ", address_id, flush=True)

    # zkontrolovat existenci jidel a vzit ceny z databaze
    for item in menu:
        food = db.execute("SELECT * FROM food WHERE id = ? and is_public = 'true'", (int(item["id"]),)).fetchone()
        formatted_food = row_to_dict(food)
        if not formatted_food:
            return json_response("bad_request")
        final_price += formatted_food["price"] * item["count"]
    print("finalní cena: ", final_price, flush=True)

    # vytvorit objednavku
    making_time = estimated_time(custom_address)
    print("zhotovení za: ", making_time, flush=True)
    db.execute("INSERT INTO 'order'(price, is_done, user_id, address_id, making_time) VALUES (?, ?, ?, ?, ?)",
               (final_price, "false", g.user["id"], address_id, making_time))
    order_id = db.execute("SELECT last_insert_rowid()").lastrowid

    # spojit vytvořenou objednávku s jídly
    for item in menu:
        for i in range(item["count"]):
            db.execute("INSERT INTO orderFoodLink(order_id, food_id) VALUES (?, ?)",
                       (order_id, item["id"]))

    db.commit()
    return json_response("ok", data={
        "price": final_price,
        "makingTime": making_time
    })


def estimated_time(custom_address):
    time = 20 if not custom_address else 40

    today = datetime.datetime.today().weekday()
    if today == 5 or today == 6:
        time += 5

    now = datetime.datetime.now().time()
    lunch_from = datetime.time(11, 0, 0)
    lunch_to = datetime.time(13, 0, 0)
    dinner_from = datetime.time(17, 0, 0)
    dinner_to = datetime.time(19, 0, 0)

    if lunch_from <= now <= lunch_to or dinner_from <= now <= dinner_to:
        time += 10

    return time


def get_order_and_food(db, order_id):
    order = row_to_dict(db.execute("select * from 'order' where id = ?", (order_id,)).fetchone())
    food = rows_to_dict(db.execute(
        """
        select f.id, f.title, f.ingredients, f.price, f.category
        from "order" join orderFoodLink oFL on "order".id = oFL.order_id join food f on oFL.food_id = f.id
        where "order".id == ?;
        """,
        (order_id, )).fetchall())

    return order, food
