# t-shirt-shop

## Project setup

- install the correct ruby version (see `.ruby-version` file)
- install the correct node versione (see `.nvmrc`)
- run `bundle install` to install ruby gems
- run `yarn install` to install node_modules
- check that `config/database.yml` contains the correct settings for your db (You can setup one using the `docker-compose.yml` file insluded in the project root)
- run `rails db:create`, then `rails dm:migrate`

## Run the project for development

- you may want to run `rails db:seed` to generate example data
- run `bin/dev`
