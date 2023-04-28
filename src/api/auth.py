import functools
from src.http_response import json_response
import re

from flask import Blueprint, g, request, session
from werkzeug.security import check_password_hash, generate_password_hash
from db import get_db, row_to_dict


"""
You must at the very least check for Content-Type: application/json on the request.

It's not possible to get a POSTed <form> to submit a request with Content-Type: application/json. 
But you can submit a form with a valid JSON structure in the body as enctype="text/plain".

It's not possible to do a cross-origin (CORS) XMLHttpRequest POST with Content-Type: application/json against 
a non-cross-origin-aware server because this will cause a ‘pre-flighting’ HTTP OPTIONS request to approve it first. 
But you can send a cross-origin XMLHttpRequest POST withCredentials if it is text/plain.

So even with application/json checking, you can get pretty close to XSRF, if not completely there. And the behaviours 
you're relying on to make that secure are somewhat obscure, and still in Working Draft stage; 
they are not hard-and-fast guarantees for the future of the web.

These might break, for example if a new JSON enctype were added to forms in a future HTML version. 
(WHATWG added the text/plain enctype to HTML5 and originally tried also to add text/xml, 
so it is not out of the question that this might happen.) You increase the risk of compromise from smaller, 
subtler browser and plugin bugs in CORS implementation.

So whilst you can probably get away with it for now, I absolutely wouldn't recommend going forward without 
a proper anti-XSRF token system.
"""


bp = Blueprint('auth', __name__, url_prefix='/auth')

EMAIL_REGEX = r"^\S+@\S+\.\S+$"
PASSWORD_REGEX = r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$"

@bp.before_app_request
def load_logged_in_user():
    if request.method in ("PUT", "POST") and request.content_type != "application/json":
        return json_response("forbidden")

    session.permanent = True

    user_id = session.get('user_id')
    print("BEFORE_REQUEST ID FOUND: ", user_id, flush=True)

    if user_id is None:
        g.user = None
    else:
        user = get_db().execute('SELECT * FROM user WHERE id = ?', (user_id,)).fetchone()
        g.user = row_to_dict(user) # password is dropped automatically


def login_required(endpoint):
    @functools.wraps(endpoint)
    def wrapped_view(**kwargs):
        print("LOGIN_REQUIRED_CHECK", g.user)
        if g.user is None:
            return json_response("unauthorized")
        return endpoint(**kwargs)

    return wrapped_view


def admin_login_required(endpoint):
    @functools.wraps(endpoint)
    def wrapped_view(**kwargs):
        print("ADMIN_LOGIN_REQUIRED_CHECK", g.user)
        if g.user is None or g.user["role"] != "admin":
            return json_response("unauthorized", message="Přístupné pouze adminům")
        return endpoint(**kwargs)

    return wrapped_view


@bp.route('/register', methods=["POST"])
def register():
    name = request.json['name'].strip()
    email = request.json['email'].strip()
    password = request.json['password'].strip()
    db = get_db()

    if not re.match(EMAIL_REGEX, email) or not re.match(PASSWORD_REGEX, password) or not name:
        return json_response("bad_request")

    values = (name, email, generate_password_hash(password))
    try:
        db.execute("INSERT INTO user (name, email, password) VALUES (?, ?, ?)", values)
        db.commit()
    except db.IntegrityError as e:  # User already exist
        print(e, flush=True)
        error = f"User {email} is already registered."
        return json_response("conflict", message=error)

    return login_user(True)


@bp.route("/login-google/", methods=["POST"])
def login_google_user():
    email = request.json["email"].strip()
    name = request.json["name"].strip()
    id_ = request.json["id"].strip()
    db = get_db()

    # try to find user
    user = db.execute('SELECT * FROM user WHERE google_id = ? AND email = ?', (id_, email)).fetchone()
    if user is None:
        # need to be registered
        try:
            name_or_anonym = "Anonym" if not name else name
            db.execute("INSERT INTO user (name, email, password, google_id) VALUES (?, ?, ?, ?)",
                       (name_or_anonym, email, "", id_))
            db.commit()
            user_id = db.execute("SELECT last_insert_rowid()").lastrowid
        except db.IntegrityError as e:  # User with that email already exist
            print(e)
            return json_response("conflict")
    else:
        user_id = user["id"]

    # login
    # try to find user
    session.clear()
    session['user_id'] = user_id
    return json_response("ok")


@bp.route('/login', methods=['POST'])
def login_user(from_registration=False):
    email = request.json['email'].strip()
    password = request.json['password']

    if not re.match(EMAIL_REGEX, email):
        return json_response("bad_request")

    db = get_db()

    user = db.execute('SELECT * FROM user WHERE email = ?', (email, )).fetchone()
    if user and user["google_id"]:
        return json_response("google")  # nedovolime mu se prihlasit beznym zpusobem

    if user is None or not check_password_hash(user['password'], password):
        return json_response("not_found")

    session.clear()
    session['user_id'] = user['id']
    if from_registration:
        return json_response("created")
    else:
        return json_response("ok")


@bp.route('/logout')
def logout():
    session.clear()
    return json_response("ok")
