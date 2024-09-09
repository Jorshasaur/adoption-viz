# Texas Adoption Visualization

This project is a demo project that renders data from the [Texas Open Data Portal](https://data.texas.gov/dataset/CPS-4-5-Adoptions-Consummated-by-County-FY2014-202/fg8z-fzm6/about_data) around successful adoptions from the period of 2014 - 2023.

## Technology

The project is built with this technology:
- Ruby on Rails: the baseline server
- Postgres: houses the actual adoption data ported over from Texas
- React: renders the front end
- GraphQL: used to communicate with Rails and also filter the data by year
- Front End Map: the state map of Texas comes from simplemaps.com, I'm passing in the data to rerender it (I did not build the map)
- TailwindCSS: the visual layout and CSS

## Deployment
The server and code currently deploy to Heroku on merges to the `main` branch.  The Postgres database is hosted in a cluster on DigitalOcean.  The data from Texas has been copied down into a file called `adoptions_input.csv` in `/db/data` and is transformed a bunch to get be more usable with the map component.

## Running Locally
### Using Docker and Docker Compose
You can run the project from Docker without running with a local Ruby and Rails installation.  These are the commands you should run from the root of the project:

1. `docker-compose build`
2. `docker-compose run app rails db:create db:migrate` - This creates the database and tables in Postgres
3. `docker-compose run app rake import_adoptions` - This seeds the database with the adoption records
3. `docker-compose up -d`

After the container starts it should be accessible from [http://localhost:3000](http://localhost:3000).

### Without Docker
There are a few env vars that you will need (mostly for Postgres) if you're running the project without Docker.   I prefer to use direnv and a `.envrc` file, but so long as you set:
```
DATABASE_HOST
DATABASE_USERNAME
DATABASE_PASSWORD
DATABASE_PORT
```

Then there are a few more commands to get things installed:

1. `npm install` - installs all the Node dependencies
2. `bundle install` - installs all the gems for the project
3. `rails db:create db:migrate` - creates the database and runs migrations
4. `rake import_adoptions` - imports the adoptions data from the adoptions csv

And the start up command is: `bin/dev`

After that you should be able to navigate to [http://localhost:3000](http://localhost:3000).

## Architecture

### Front End
The project's React front end has three components:

- `app/javascript/bundles/Map/components/MapControls.jsx`: this component holds the `YearSelector` component, the `MapManager` component and the enormous date that also updates with the year change.  The idea here was that `MapControls` acts as the main controller with the state for the currently selected year.  I thought about using a state management library but this example was so simple it seemed like overkill.
- `app/javascript/bundles/Map/components/YearSelector.jsx`: this component contains the logic and display for the year navigator and calls a prop function to change the date.
- `app/javascript/bundles/Map/components/MapManager.jsx`: this component does the calls to GraphQL, cleans the response for the map, and updates the map component with the new data.

### Back End
The back end uses GraphQL to deliver data to the React frontend.

- `app/controllers/map_controller.rb` - the only real controller in Rails that only serves the map index page
- `app/views/map/index.html.erb` - the map index page that holds most of the HTML and loads `MapControls` (see Front End).  The project uses React on Rails so I'm using the helper to write the component to the page.
- `app/graphql/types/query_type.rb` - The only query that I'm using here in the project which is the adoptions data by year

### Data Cleanup
The data from Texas is really great but I needed to change it to work in a map, add color data, and fill in the places where counties had zero adoptions since the Texas CVS just left those out.  If you look at `lib/tasks/import.rake` you can see all the steps to clean, colorize, and format the data.

## What Would I Change?
1. The data in Postgres could be normalized, I'm repeating data in places when that isn't the most efficient.  The data could be broken out by number of adoptions with keys for counties and year.  If this were a real project and the data didn't update frequently, that could be an over optimization.
2. The third party map I used is really cool but quirky in the way that it runs.  I'm just including the JS from that component in the public folder and loading it directly in the `map.html.erb` layout.  That's not great, ideally it would be bundled with the rest of the Javascript but I kept running into issues when I served it from the `vendor` folder.  Since it didn't seem important, I just skipped over that for now.
3. Map Colors!  I played a lot with how to colorize the map so it looked exciting.  The thing is that while the number of adoptions change per county, the counties that have lots of adoptions tend to have lots every year.  So if you jump back and forth between the years its not that visually exciting.  If this were real I'd probably add something like animations to emphasis the changes.  And the map needs a loading screen because there is a delay between the data being loaded from GraphQL and rendering.  It's a brief flash now, which I think is fine for a demo.

## Running Tests
TODO