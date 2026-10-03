#### Dockerfile Reference
https://docs.docker.com/reference/dockerfile

---
#### Build docker image counting-service
```
docker build -t counting-service:0.1 .
```
#### Run docker image locally
```
docker run -it -p 9000:9001 counting-service:0.1
```
#### Login
```
docker login
```
#### Tag
````
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker tag counting-service:0.1 hnin6060hlaing/counting-service:0.1
````
#### Push to docker hub
```
docker push hnin6060hlaing/counting-service:0.1
```
---
#### Build docker image dashboard-service
```
docker build -t dashboard-service:0.1 .
```
#### Run docker image locally
```
docker run -it -p 8000:9002 -e COUNTING_SERVICE_URL=http://host.docker.internal:9000 dashboard-service:0.1
```
#### Tag
```
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker tag dashboard-service:0.1 hnin6060hlaing/dashboard-service:0.1
```
#### Push to docker hub
```
docker push hnin6060hlaing/dashboard-service:0.1
```
---
#### Build docker image dashboard-service-v2
```
docker build -t dashboard-service:0.2 .
```
#### Run docker image locally
```
docker run -it -p 8000:9002 -e COUNTING_SERVICE_URL=http://host.docker.internal:9000 dashboard-service:0.2
```
#### Tag
```
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker tag dashboard-service:0.2 hnin6060hlaing/dashboard-service:0.2
```
#### Push to docker hub
```
docker push hnin6060hlaing/dashboard-service:0.2
```
---
#### My docker hub repositories are here.
https://hub.docker.com/repository/docker/hnin6060hlaing/counting-service/tags
https://hub.docker.com/repository/docker/hnin6060hlaing/dashboard-service/tags
