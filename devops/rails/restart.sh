chmod +x ./devops/rails/restart.sh

echo "Installing gems..."
bundle install
docker compose run app bundle install

echo "Running database commands for $RAILS_ENV..."
docker compose run -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 app rails db:drop RAILS_ENV=$RAILS_ENV 
docker compose run app rails db:create RAILS_ENV=$RAILS_ENV
docker compose run app rails db:migrate RAILS_ENV=$RAILS_ENV
docker compose run app rails db:seed RAILS_ENV=$RAILS_ENV