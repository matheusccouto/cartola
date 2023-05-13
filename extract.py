"""Extract data from Cartola API."""

import argparse
import json

import requests

URL = "https://api.cartola.globo.com/"


def extract(endpoint):
    """Extract and normalize data."""
    response = requests.get(URL + endpoint, timeout=5)
    response.raise_for_status()
    return json.dumps(json.loads(response.text), indent=2)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("endpoint")
    args = parser.parse_args()
    print(extract(args.url))
