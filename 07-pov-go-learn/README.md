### Clone to working directory
```
git clone https://github.com/hashicorp/http-echo.git 
cd http-echo
```
### Build 
```
mkdir -p dist/linux/arm64
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o ../dist/linux/arm64/http-echo .
chmod +x ../dist/linux/arm64/http-echo
```
### Remove folder
```
cd ..
rm -rf http-echo
```
### Build docker image counting-service
```
docker build -t go-learn:0.1 .
```
### Run docker image locally
```
# server is listening on 5678 by default
docker run -it -p 9000:5678 go-learn:0.1 
docker run -it -p 9000:9001 go-learn:0.1 -listen=:9001 -text="Hello from Docker!"
```
### Tag
```
docker tag go-learn:0.1 hnin6060hlaing/go-learn:0.1
```
### Push to docker hub
```
docker push hnin6060hlaing/go-learn:0.1
```
