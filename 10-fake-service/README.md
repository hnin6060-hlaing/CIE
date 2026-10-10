
### As a practice exercise, use fake-service to run as BookInfo Style Architecture.
1. run as binary
2. run as containers (using docker compose)

# Binaries: 
https://github.com/nicholasjackson/fake-service/releases/

# Run as binary
#### Rating
```
LISTEN_ADDR="0.0.0.0:9001" \
MESSAGE="Rating App" \
NAME="Rating App (Fake Service)" \
./fake-service
```
#### Review V1
```
LISTEN_ADDR="0.0.0.0:9002" \
MESSAGE="Review V1 App" \
NAME="Review V1 App (Fake Service)" \
./fake-service
```
#### Review V2
```
LISTEN_ADDR="0.0.0.0:9003" \
MESSAGE="Review V2 App" \
NAME="Review V2 App (Fake Service)" \
UPSTREAM_URIS="0.0.0.0:9001" ./fake-service
```
#### Review V3
```
LISTEN_ADDR="0.0.0.0:9004" \
MESSAGE="Review V3 App" \
NAME="Review V3 App (Fake Service)" \
UPSTREAM_URIS="0.0.0.0:9001" ./fake-service
```
#### Detail
```
LISTEN_ADDR="0.0.0.0:9005" \
MESSAGE="Detail App" \
NAME="Detail App (Fake Service)" \
./fake-service
```
#### Product
```
LISTEN_ADDR="0.0.0.0:9006" \
MESSAGE="Product App" \
NAME="Product App (Fake Service)" \
UPSTREAM_URIS="0.0.0.0:9002,0.0.0.0:9003,0.0.0.0:9004,0.0.0.0:9005" ./fake-service
```
