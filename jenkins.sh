sudo docker compose -f docker-compose-jenkins.yml -p jenkins stop
sudo docker compose -f docker-compose-jenkins.yml -p jenkins rm --force -v

sudo docker compose -f docker-compose-jenkins.yml -p jenkins build --no-cache
sudo docker compose -f docker-compose-jenkins.yml -p jenkins up -d

sudo docker compose -f docker-compose-jenkins.yml -p jenkins run --no-deps --rm -e ENV=UNIT identidock

ERR=$?

if [ $ERR -eq 0 ]; then
    sudo docker network connect jenkins_default jenkins
    IP=$(sudo docker inspect -f {{.NetworkSettings.Networks.jenkins_default.IPAddress}} jenkins-identidock-1)
    CODE=$(curl -sL -w "%{http_code}" $IP:9090/monster/bla -o /dev/null) || true
    if [ $CODE -eq 200 ]; then
        echo "Test passed - Tagging"
        HASH=$(git rev-parse --short HEAD)
        sudo docker tag jenkins-identidock andrkrutsch/identidock:$HASH
        sudo docker tag jenkins-identidock andrkrutsch/identidock:newest
        echo "Pushing"
        # sudo docker login -e <email> -u <login> -p <password>
        # sudo docker push andrkrutsch/identidock:$HASH
        # sudo docker push andrkrutsch/identidock:newest
    else
        echo "Site returned " $CODE
        ERR=1
    fi
fi

sudo docker compose -f docker-compose-jenkins.yml -p jenkins stop
sudo docker compose -f docker-compose-jenkins.yml -p jenkins rm --force -v
sudo docker network disconnect jenkins_default jenkins
sudo docker network prune --force

return $ERR