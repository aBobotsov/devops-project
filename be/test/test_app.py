import json
from flask.testing import FlaskClient
import pytest

from be.src.app import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_valid_input(client: FlaskClient):
    response = client.post(

        '/validate',
        data=json.dumps({'input': '2'}),
        content_type='application/json'
    )
    data = json.loads(response.data.decode())
    assert response.status_code == 200
    assert data["isValid"]


def test_invalid_input(client: FlaskClient):
    response = client.post(
        "/validate", data=json.dumps({"input": "3"}), content_type="application/json"
    )
    data = json.loads(response.data.decode())
    assert response.status_code == 200
    assert not data["isValid"]


def test_missing_input(client: FlaskClient):
    response = client.post(
        "/validate", data=json.dumps({}), content_type="application/json"
    )
    data = json.loads(response.data.decode())
    assert response.status_code == 500
    assert "error" in data
