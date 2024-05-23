"""Module to find if the city is capital for the given state."""

from pathlib import Path
import json
from typing import List

THIS_DIR = Path(__file__).parent
CITIES_JSON_FPATH = THIS_DIR / "./cities.json"

def is_city_capital_of_state(city: str, state: str) -> bool:
    """Return boolean whether city is the capital of a given state"""

    cities_json_contents = CITIES_JSON_FPATH.read_text()
    cities: List[dict] = json.loads(cities_json_contents)
    matching_cities: List[dict] = [city for city in cities if city["city"]==city]
    if len(matching_cities) == 0:
        return False
    else:
        matched_city = matching_cities[0]
        return matched_city["state"] == state

if __name__=="__main__":
    is_capital = is_city_capital_of_state(city="Montgomery", state="Alabama")
    print(f"is capital: {is_capital}")
