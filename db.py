import sqlite3

import click
from flask import current_app, g
from typing import Optional


def row_to_dict(row: sqlite3.Row, *drop_args) -> Optional[dict]:
    if not row: return None

    result = {key: row[key] for key in row.keys()}
    if "password" in result:
        del result["password"]

    for drop_arg in drop_args:
        if drop_arg in result:
            del result[drop_arg]

    return result


def rows_to_dict(rows: list[sqlite3.Row], *drop_args) -> list[dict]:
    return [row_to_dict(row, *drop_args) for row in rows]


def get_db():
    if 'db' not in g:
        g.db = sqlite3.connect(
            current_app.config['DATABASE'],
            detect_types=sqlite3.PARSE_DECLTYPES
        )
        g.db.row_factory = sqlite3.Row
    return g.db


def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()


def init_db():
    db = get_db()

    with current_app.open_resource('database/schema.sql') as f:
        db.executescript(f.read().decode('utf8'))


@click.command('init-db')
def init_db_command():
    """Clear the existing data and create new tables."""
    init_db()
    click.echo('Initialized the database.')


def init_app(app):
    app.teardown_appcontext(close_db)
    app.cli.add_command(init_db_command)
