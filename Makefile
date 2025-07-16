# Run the app with Docker Compose
up:
	docker compose up

# Build Docker containers
build:
	docker compose build

# Stop and remove containers
down:
	docker compose down

# Rebuild and run
restart:
	docker compose down
	docker compose build
	docker compose up
