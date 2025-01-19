
chmod +x ./devops/rails/update.sh

echo "Running database migrations"
docker compose run app rails db:migrate

echo "Pruning stopped containers..."
docker container prune -f

echo "Done."
