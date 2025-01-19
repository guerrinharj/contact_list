# Ensure the devops/compose directory has executable scripts
chmod +x ./devops/compose/build.sh

echo "Installing dependencies and gems..."
bundle install

echo "Building Docker images..."
docker compose build

echo "Running bundle install in the web service..."
docker compose run app bundle install

echo "Generating RSpec configuration..."
docker compose run app rails generate rspec:install