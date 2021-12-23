## Run the following as root
## Execute using 
## curl -s https://raw.githubusercontent.com/supachai-j/install-k8s-ubuntu/main/install-K8s.sh | bash -s "1.16.7-00"
## You can check available kubernetes version
## curl -s https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages | grep Version | awk '{print $2}'

#!/bin/bash
echo "Kubernetes vanilla installation begins using KubeADM"
apt-get clean
rm /var/lib/dpkg/lock    
rm /var/cache/apt/archives/lock
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
sleep 1
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sleep 2
apt-get update -y 
sleep 1
export DEBIAN_FRONTEND=noninteractive
apt-get install -y libpq-dev apt-transport-https curl docker.io
sleep 1
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sleep 1 
systemctl daemon-reload
systemctl restart docker
systemctl enable docker
sleep 1 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sleep 1 
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sleep 1 
#Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
apt-get update
##Workaround to disable swap on Linux host 
#sed -i -e '2s/^/#/' /etc/fstab
echo "KUBERNETES DEFAULT PACKAGE INSTALLATION BEGINS"
# apt-get install -y kubelet kubeadm kubectl

if [ -z "$1" ]
then
   apt-get install -y kubelet kubeadm kubectl
else
   sudo apt-get install -qy kubelet=$1 kubectl=$1 kubeadm=$1
fi

kubeadm init --pod-network-cidr 10.224.0.0/16 --apiserver-advertise-address=192.168.55.122 --apiserver-bind-port=6443 > /kub.txt
mkdir -p $HOME/.kube && cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
sleep 5
echo "COMPLETED"
echo "."
echo "."
echo "."
echo "Now some finetuning by Jay"
echo "."
echo "Enabling you to run kubectl commands as ubuntu user & run docker without sudo"
echo "."
sleep 5

su vagrant
sudo cp -r /root/.kube $HOME
sudo chown -R $USER $HOME/.kube
sudo chgrp -R $USER $HOME/.kube
sudo su
su vagrant
sudo usermod -aG docker ${USER}
id -nG
sudo su
su vagrant

#### FINISH 

## Thanks to my good friend Giriraj: https://github.com/learnbyseven

## FOR ADDING NODE
## curl -s https://raw.githubusercontent.com/supachai-j/install-k8s-ubuntu/main/add_node_k8.sh | bash 
