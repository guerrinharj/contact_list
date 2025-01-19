chmod +x ./devops/rails/restart.sh

echo "Running database commands"
docker compose run -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 app rails db:drop 
docker compose run app rails db:create
docker compose run app rails db:migrate 
docker compose run app rails db:seed