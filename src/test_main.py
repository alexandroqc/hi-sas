from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_read_item():
    response = client.get("/", headers={"User-Agent": "SAS"})
    assert response.status_code == 200
    assert response.json() == {
        "message": "Welcome to 2022",
        "User-Agent": "SAS",
    }
