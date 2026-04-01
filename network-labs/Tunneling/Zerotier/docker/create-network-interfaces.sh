docker network create \
  --driver=bridge \
  --subnet=172.20.20.0/24 \
  --gateway=172.20.20.1 \
  -o com.docker.network.bridge.name=docker-zerotier \
  docker-zerotier