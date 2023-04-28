import os
from flask import Flask
import json


def create_app():
    if os.environ.get("FLASK_DEBUG"): # dev mode
        # pokud je FE ve stejném adresáři, pak bude backend servírovat data ze složky ../restaurant_FE/build
        app = Flask(__name__, static_folder="..\\restaurant_FE\\build",
                    template_folder="..\\restaurant_FE\\build", instance_relative_config=True)
    else:
        # v případě produkčního spuštění, bude backend servírovat data ze složky ./build
        app = Flask(__name__, static_folder="build", template_folder="build", instance_relative_config=True)

    app.config.from_file("..\\config.json", load=json.load)
    app.config["DATABASE"] = os.path.join(os.path.dirname(__file__) + "\\database\\", "sqlite")

    import db
    db.init_app(app)

    from src.api import auth, index, user, food, order
    app.register_blueprint(index.bp)
    app.register_blueprint(auth.bp)
    app.register_blueprint(user.bp)
    app.register_blueprint(food.bp)
    app.register_blueprint(order.bp)

    return app
