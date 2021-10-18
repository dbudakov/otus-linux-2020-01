sudo yum check-update
curl -fsSL https://get.docker.com/ | sed 's/sleep 20/sleep 2/g' | sh
sudo usermod -aG docker root 
sudo systemctl start docker
sudo systemctl enable docker
