# 虚拟机

## 记·超算hadoop集群迁移到实验室vsphere虚拟机

* 超算中心导出raw镜像
* 下载一个qemu-img（免费），raw镜像转vmdk供vmware使用

`qemu-img convert -f raw master.raw -O vmdk master.vmdk`

* vmware workstation（免费试用30天）创建虚拟机，选择现有磁盘master.vmdk，会产生vmx文件，供vcenter converter使用
* vmware vcenter converter（永久免费）选择master.vmx，转到vsphere esxi机器上（通过ip和帐密登录）
* 转换完毕，vsphere client打开新的虚拟机

