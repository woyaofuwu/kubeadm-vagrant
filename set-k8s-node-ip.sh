#!/bin/sh

# kubelet 设置正确的 ip：这个是 vagrant 的一个坑，vagrant 在多主机模式时主机 eth0 网卡是 nat 的 ip，而 eth1 才是主机的私有 ip
# kubelet 默认读取的是 eth0 网卡 ip，所以会出问题。需要集群创建后设置正确的节点 ip，然后重启 kubelet。
echo KUBELET_EXTRA_ARGS=\"--node-ip=`ip addr show eth1 | grep inet | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}/" | tr -d '/'`\" > /etc/sysconfig/kubelet
systemctl restart kubelet
