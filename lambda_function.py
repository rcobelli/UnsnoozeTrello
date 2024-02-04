import requests
import dateutil.parser
from datetime import datetime
import os

def handler(event, context):
    print(os.environ['TrelloLists'])

    lists = os.environ['TrelloLists'].split(",")
    for list in lists:
        print("Processing list " + list)
        processCards(list.strip())

    print("Done!")


def processCards(listid):
    key=os.environ['TrelloApiKey']
    token=os.environ['TrelloApiToken']

    url = "https://api.trello.com/1/lists/" + listid + "?cards=closed&key=" + key + "&token=" + token
    data = requests.get(url).json()

    for card in data['cards']:
        if card['due'] is not None:
            date = dateutil.parser.parse(card['due'])
            if date.date() <= datetime.today().date():
                print("Un-snoozing card " + card['id'])
                # Update the card so it isn't closed (archived) and has no due date
                url = "https://api.trello.com/1/cards/" + card['id']
                data = {"closed": "false", "due" : "null", "key" : key, "token" : token}
                requests.put(url, data = data)
