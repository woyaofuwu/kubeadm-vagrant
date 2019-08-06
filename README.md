# kubeadm-vagrant
Setup Kubernetes Cluster with Kubeadm and Vagrant

Introduction
使用 kubeadm + vagrant 自动化部署 k8s 集群，基于 Centos7 操作系统。该工程 fork 自 [kubeadm-vagrant](https://github.com/coolsvap/kubeadm-vagrant),  对已知问题进行了修复：节点设置正确的 IP 地址[「set-k8s-node-ip.sh」](./set-k8s-node-ip.sh)。否则使用过程中会出现问题，具体问题见这里：[「kubeadm + vagrant 部署多节点 k8s 的一个坑」](https://qhh.me/2019/08/06/kubeadm-vagrant-%E9%83%A8%E7%BD%B2%E5%A4%9A%E8%8A%82%E7%82%B9-k8s-%E7%9A%84%E4%B8%80%E4%B8%AA%E5%9D%91/)。其他一些调整：节点初始化脚本更改、Vagrantfile 添加 Shell 脚本配置器，运行初始化脚本。

With reference to steps listed at [Using kubeadm to Create a Cluster](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) for setting up the Kubernetes cluster with kubeadm. I have been working on an automation to setup the cluster. The result of it is [kubeadm-vagrant](https://github.com/coolsvap/kubeadm-vagrant), a github project with simple steps to setup your kubernetes cluster with more control on vagrant based virtual machines.

Vagrant Box
- Centos7

Installation

- Clone the kubeadm-vagrant repo

```https://github.com/qhh0205/kubeadm-vagrant ```

- Configure the cluster parameters in Vagrantfile. Refer below for details of configuration options.

``` vi Vagrantfile ```

- Spin up the cluster

`vagrant up`

- This will spin up new Kubernetes cluster. You can check the status of cluster with following command,
```
sudo su
kubectl get pods --all-namespaces
```
Cluster Configuration Options

You need to generate a KUBETOKEN of your choice to be used while creating the cluster. You will need to install kubeadm package on your host to create the token with following command

```
# kubeadm token generate 
148a37.736fd53655b767b7
```

1. ``` BOX_IMAGE ``` is currently default with &quot;coolsvap/centos-k8s&quot; box which is custom box created which can be used for setting up the cluster with basic dependencies for kubernetes node.
2. Set ``` SETUP_MASTER ``` to true if you want to setup the node. This is true by default for spawning a new cluster. You can skip it for adding new minions.
3. Set ``` SETUP_NODES ``` to true/false depending on whether you are setting up minions in the cluster.
4. Specify ``` NODE_COUNT ``` as the count of minions in the cluster
5. Specify  the ``` MASTER_IP ``` as static IP which can be referenced for other cluster configurations
6. Specify ``` NODE_IP_NW ``` as the network IP which can be used for assigning dynamic IPs for cluster nodes from the same network as Master
7. Specify custom ``` POD_NW_CIDR ``` of your choice

