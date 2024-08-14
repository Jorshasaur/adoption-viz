# Texas Adoption Visualization

This project is a demo project that renders data from the [Texas Open Data Portal](https://data.texas.gov/dataset/CPS-4-5-Adoptions-Consummated-by-County-FY2014-202/fg8z-fzm6/about_data) around successful adoptions from the period of 2014 - 2023.

## Technology

The project is built with this technology:
- Ruby on Rails: the baseline server
- Postgres: houses the actual adoption data ported over from Texas
- React: renders the front end
- GraphQL: used to communicate with Rails and also filter the data by year
- Front End Map: the state map of Texas comes from simplemaps.com, I'm passing in the data to rerender it (I did not build the map)

## Deployment
The server and code currently deploy to Heroku on merges to the `main` branch.  The Postgres database is hosted in a cluster on DigitalOcean.  The data from Texas has been copied down into a file called `adoptions_input.csv` in `/db/data` and is transformed a bunch to get be more usable with the map component.

## Running Locally
TODO

## Running Tests
TODO