# Dockerfile Reference
https://docs.docker.com/reference/dockerfile

# Build docker image counting-service
docker build -t counting-service:0.1 .
# Run docker image locally
docker run -it -p 9000:9001 counting-service:0.1

# Build docker image dashboard-service
docker build -t dashboard-service:0.1 .
# Run docker image locally
docker run -it -p 8000:9001 dashboard-service:0.1