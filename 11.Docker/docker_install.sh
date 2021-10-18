sudo yum check-update
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker root 
sudo systemctl start docker
sudo systemctl enable docker
