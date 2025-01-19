chmod +x ./devops/compose/exec.sh

echo "Starting an interactive shell in the app container."
docker compose exec app bash
