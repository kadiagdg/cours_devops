import pytest
from fastapi.testclient import TestClient
import sys
import os

# Add the parent directory to sys.path to allow importing from main
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from main import app

@pytest.fixture(scope="function")
def client():
    """Create a simple test client."""
    with TestClient(app) as test_client:
        yield test_client
