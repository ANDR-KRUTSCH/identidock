For running clear Identidock scenarios use one of the following commands:

docker compose -f docker-compose-dev.yml up
docker compose -f docker-compose-prod.yml up
docker compose -f docker-compose-prod-proxy.yml up


For running Identidock with Jenkins server use the following commands:

cd identijeck
docker build -t identijeck .
docker run --name jenkins-data identijeck echo "Jenkins Data Container"
docker run -d --name jenkins -p 8080:8080 --volumes-from jenkins-data -v /var/run/docker.sock:/var/run/docker.sock identijeck


For running Identidock without using Docker Compose copy the files from ./etc/systemd/system/ to /etc/systemd/system/ on host and then use the following command:

systemctl start identidock.*