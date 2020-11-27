BOX_IMAGE = "centos/7"
SETUP_MASTER = true
SETUP_NODES = true
NODE_COUNT = 1
MASTER_IP = "192.168.26.10"
NODE_IP_NW = "192.168.26."
POD_NW_CIDR = "10.244.0.0/16"

#初始化集群 TOKEN，为了自动化，需要提前用 kubeadm 生成，也可以用下面的 TOKEN，但是生产环境建议重新生成下。
#Generate new using steps in README
KUBETOKEN = "b029ee.968a33e8d8e6bb0d"

#k8s node 节点执行的脚本，将节点加入集群
$kubeminionscript = <<MINIONSCRIPT

kubeadm reset

kubeadm join --discovery-token-unsafe-skip-ca-verification --token #{KUBETOKEN} #{MASTER_IP}:6443


MINIONSCRIPT

#k8s master 节点执行的脚本：kubeadm 部署 master 节点
$kubemasterscript = <<SCRIPT

kubeadm reset
# --image-repository registry.aliyuncs.com/google_containers：kubernetes 组件阿里云镜像，国内无法直接从 google 拉取
kubeadm init --image-repository registry.aliyuncs.com/google_containers --apiserver-advertise-address=#{MASTER_IP} --pod-network-cidr=#{POD_NW_CIDR} --token #{KUBETOKEN} --token-ttl 0

mkdir -p $HOME/.kube
sudo cp -Rf /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 改了下 flannel 启动参数，适配 vagrant 多网卡情况，否则部署后 DNS 无法解析
kubectl apply -f /vagrant/kube-flannel.yml


SCRIPT


Vagrant.configure("2") do |config|
  config.vm.box = BOX_IMAGE
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |l|
    l.cpus = 2
    l.memory = "2048"
  end

  if SETUP_MASTER
    config.vm.define "master" do |subconfig|
      subconfig.vm.hostname = "master"
      subconfig.vm.network :private_network, ip: MASTER_IP
      subconfig.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
      subconfig.vm.provision :shell, path: "install-centos.sh"
      subconfig.vm.provision :shell, inline: $kubemasterscript
      subconfig.vm.provision :shell, path: "set-k8s-node-ip.sh"
    end
  end
  
  if SETUP_NODES
    (1..NODE_COUNT).each do |i|
      config.vm.define "node#{i}" do |subconfig|
        subconfig.vm.hostname = "node#{i}"
        subconfig.vm.network :private_network, ip: NODE_IP_NW + "#{i + 10}"
        subconfig.vm.provision :shell, path: "install-centos.sh"
        subconfig.vm.provision :shell, inline: $kubeminionscript
        subconfig.vm.provision :shell, path: "set-k8s-node-ip.sh"
      end
    end
  end
end
