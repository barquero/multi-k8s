docker build -t hbarquero/multi-client:latest -t hbarquero/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t hbarquero/multi-server:latest -t hbarquero/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t hbarquero/multi-worker:latest -t hbarquero/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

docker push hbarquero/multi-client:latest
docker push hbarquero/multi-server:latest
docker push hbarquero/multi-worker:latest

docker push hbarquero/multi-client:$GIT_SHA
docker push hbarquero/multi-server:$GIT_SHA
docker push hbarquero/multi-worker:$GIT_SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=hbarquero/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=hbarquero/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=hbarquero/multi-worker:$GIT_SHA