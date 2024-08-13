docker compose -f docker-compose-dev.yml up
docker compose -f docker-compose-prod.yml up

docker run --name jenkins-data identijeck echo "Jenkins Data Container"
docker run -d --name jenkins -p 8080:8080 --volumes-from jenkins-data -v /var/run/docker.sock:/var/run/docker.sock identijeck