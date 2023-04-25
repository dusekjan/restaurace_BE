import os
from flask import Flask, request


def create_app():
    # app = Flask(__name__, static_folder="build", template_folder="build", instance_relative_config=True)
    app = Flask(__name__, static_folder="..\\restaurant\\build",
                template_folder="..\\restaurant\\build", instance_relative_config=True)

    app.config.from_mapping(
        SECRET_KEY="some_secret_for_dev",
        DATABASE=os.path.join(os.path.dirname(__file__) + "\\database\\", "sqlite"),
    )

    app.config["SESSION_COOKIE_SECURE"] = True
    app.config["RESTAURANT_OPENED"] = True

    import db
    db.init_app(app)

    from src.api import auth, index, user, food, order
    app.register_blueprint(index.bp)
    app.register_blueprint(auth.bp)
    app.register_blueprint(user.bp)
    app.register_blueprint(food.bp)
    app.register_blueprint(order.bp)

    return app
