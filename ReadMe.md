# Minikube loadbalancing 

This repo contains a simple python hello world api, some Kubernetes manifests and instructions of deploying this app in a loadbalanced way on minikube. 

The api is developed in python using Flask. To make it production ready, the code is configured to run in an application (uwsgi) and be served by a web server (nginx). 

For deployment into kubernetes, we first package the app in Docker and develop some Kubernetes manifests for deployment. 

Loadbalancing is provided by the kubernetes the service object which exposes the running application in the  cluster behind a single outward-facing endpoint which splits the traffic across the multiple pods it serves.

## Dependencies
- Machine capable of running Minikube. See setup instructions [here](https://minikube.sigs.k8s.io/docs/start/). 
- Docker installed and running on the machine
- Python 3 installed on machine

## Running the python app locally

1. Install a virtual environment.
```
python3 -m venv env
source env/bin/activate
```

2. Install dependencies
```
pip install -r code/requirements.txt
```

3. Run the app and verifythat the app is starting successfully
```
python code/app.py
```

Navigate to a web browser and enter `http://localhost:8080/hello` or `http://localhost:8080/square?number=3`. You should see output results returned.

## Packaging and running the python app in Docker

1. Build Docker image
```
docker build -t minikube-loadbalancing:v1 .
```

2. Run the application from Docker
```
// run as a daemon
docker run -d --name minikube-loadbalancing -p 8080:80 minikube-loadbalancing:v1

// run interactively
docker run -it --name minikube-loadbalancing -p 8080:80 minikube-loadbalancing:v1
```

## Deploying the application into Minikube

1. Download and start minikube. These steps are adapted from [this](https://minikube.sigs.k8s.io/docs/start/) guide for mac . 
```
# on mac

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube

minikube start
```

2. Create minikube tunnel to expose Kubernetes services of kind `Loadbalancer`. Run this command in a separate terminal window to keep the LoadBalancer running. Follow [this](https://minikube.sigs.k8s.io/docs/handbook/accessing/) guide.  
```
minikube tunnel
```

3. Build Docker image and load it into minikube registry
```
minikube image build -t minikube-loadbalancing:v1 .
```

4. Deploy the application into Kubernetes
```
kubectl create ns minikube-loadbalancing-example
kubectl apply -f kubernetes-manifests/ -n minikube-loadbalancing-example
```

5. Check the external IP of the application
```
kubectl get svc -n minikube-loadbalancing-example
```
Copy the EXTERNAL-IP. 

6. Access the application in your browser.
http://REPLACE_WITH_EXTERNAL_IP:8080/hello
