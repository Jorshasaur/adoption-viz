# README

First run steps:

- `docker-compose build`
- `docker-compose run app rails db:create db:migrate` 
- `docker-compose run app rake import_adoptions` 
- `docker-compose run app rails tailwindcss:install` _Maybe skip this step_
- `docker-compose up`

Common Commands:
- `docker-compose run app rails console`
- `docker-compose run app rails db:seed`
- `docker-compose run app rails db:drop db:create db:migrate db:seed` _Needs a shut down instance_