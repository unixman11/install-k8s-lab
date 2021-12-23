Vagrant.configure("2") do |config|

  config.vm.define "k8s-master" do |vm1|
    vm1.vm.box = "ubuntu/bionic64"
    vm1.vm.hostname = "k8s-master"
    vm1.vm.network "private_network", ip: "192.168.55.122"
    vm1.vm.provision "shell", path: "install-K8s.sh"
    vm1.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-master"
      vb.cpus = 2
      vb.memory = 2048
      #vb.customize ["modifyvm", :id, "--nic1", "natnetwork"]
      #vb.customize ["modifyvm", :id, "--nat-network1", "NatNetwork"]
    end
  end

  config.vm.define "k8s-worker1" do |vm2|
    vm2.vm.box = "ubuntu/bionic64"
    vm2.vm.hostname = "k8s-worker1"
    vm2.vm.network "private_network", ip: "192.168.55.123"
    vm2.vm.provision "shell", path: "add_node_k8.sh"
    vm2.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-worker1"
      vb.cpus = 2
      vb.memory = 2048
      #vb.customize ["modifyvm", :id, "--nic1", "natnetwork"]
      #vb.customize ["modifyvm", :id, "--nat-network1", "NatNetwork"]
    end
  end

  config.vm.define "k8s-worker2" do |vm3|
    vm3.vm.box = "ubuntu/bionic64"
    vm3.vm.hostname = "k8s-worker2"
    vm3.vm.network "private_network", ip: "192.168.55.124"
    vm3.vm.provision "shell", path: "add_node_k8.sh"
    vm3.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-worker2"
      vb.cpus = 2
      vb.memory = 2048
      #vb.customize ["modifyvm", :id, "--nic1", "natnetwork"]
      #vb.customize ["modifyvm", :id, "--nat-network1", "NatNetwork"]
    end
  end

end
