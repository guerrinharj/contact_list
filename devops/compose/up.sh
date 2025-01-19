# Ensure the up script is executable
chmod +x ./devops/compose/up.sh

# Clean up any stopped containers
echo "Cleaning up stopped Docker containers..."
docker container prune -f

# Bring up the Docker Compose services
echo "Starting Docker containers..."
docker compose up -d

echo "Docker containers are up and running."