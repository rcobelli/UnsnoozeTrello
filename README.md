# Trello
##### Delay cards without requiring an additional Power Up

## What it is
It is helpful to be able to "snooze" a card in Trello so that it doesn't re-appear until relevant. This requires a Power Up (which has billing implications) and is opaque about
which cards have been snoozed. The solution is to utilize the "Due Date" field as the "hide until" field.

This package creates a Lambda function that runs every morning to un-snooze any cards for the day.

## Installation
1. `cp params_example.json params.json`
2. Fill in the params in the JSON file
3. `./deploy.sh`
  - You can optionally provide a single argument to `deploy.sh` with the AWS profile you'd like to use

## TODO: 
  1. Add a parameter for the schedule cron
