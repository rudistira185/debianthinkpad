docker run -d \
  --name dockhand \
  --restart unless-stopped \
  -p 9100:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v dockhand_data:/app/data \
  fnsys/dockhand:latest
