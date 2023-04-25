import functools
from src.http_response import json_response

from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from werkzeug.security import check_password_hash, generate_password_hash
from db import get_db, row_to_dict

bp = Blueprint('auth', __name__, url_prefix='/auth')


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
    error = None

    if not email:
        error = 'Username is required.'
    elif not password:
        error = 'Password is required.'

    if error is None:
        values = (name, email, generate_password_hash(password))
        try:
            db.execute("INSERT INTO user (name, email, password) VALUES (?, ?, ?)", values)
            db.commit()
        except db.IntegrityError as e:  # User already exist
            print(e, flush=True)
            error = f"User {email} is already registered."
            return json_response("conflict", message=error)
    else:
        return json_response("bad_request")

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
        except Exception as e:
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
    password = request.json['password'].strip()
    db = get_db()
    error = None

    user = db.execute('SELECT * FROM user WHERE email = ?', (email, )).fetchone()
    print(user, flush=True)
    if user and user["google_id"]:
        print("TOTO JE GOOGLE")
        return json_response("google")

    if user is None:
        error = 'Incorrect username.'
    elif not check_password_hash(user['password'], password):
        error = 'Incorrect password.'

    if error is None:
        session.clear()
        session['user_id'] = user['id']
        if from_registration:
            return json_response("created")
        else:
            return json_response("ok")
    else:
        return json_response("bad_request")


@bp.route('/logout')
def logout():
    print(json_response("ok"), flush=True)
    session.clear()
    return json_response("ok")
