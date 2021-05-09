# 创建专有网络
resource "alicloud_vpc" "k8s" {
  vpc_name   = "k8s_demo"
  cidr_block = "192.168.0.0/16"
}
# 创建 Worker 交换机，创建两个可用区
resource "alicloud_vswitch" "worker_1" {
  vswitch_name = "worker_1"
  vpc_id       = alicloud_vpc.k8s.id
  cidr_block   = "192.168.1.0/24"
  zone_id      = "cn-beijing-a"
}
resource "alicloud_vswitch" "worker_2" {
  vswitch_name = "worker_2"
  vpc_id       = alicloud_vpc.k8s.id
  cidr_block   = "192.168.2.0/24"
  zone_id      = "cn-beijing-b"
}

# 创建 Pod 交换机，创建两个可用区
resource "alicloud_vswitch" "pod_1" {
  vswitch_name = "pod_1"
  vpc_id       = alicloud_vpc.k8s.id
  cidr_block   = "192.168.100.0/24"
  zone_id      = "cn-beijing-a"
}
resource "alicloud_vswitch" "pod_2" {
  vswitch_name = "pod_2"
  vpc_id       = alicloud_vpc.k8s.id
  cidr_block   = "192.168.101.0/24"
  zone_id      = "cn-beijing-b"
}

## k8s 集群创建，创建前请确保在容器服务控制台已经做过服务授权
resource "alicloud_cs_managed_kubernetes" "kubernetes_cluster" {
  name                  = var.k8s_name
  worker_vswitch_ids    = [alicloud_vswitch.worker_1.id, alicloud_vswitch.worker_2.id]
  pod_vswitch_ids       = [alicloud_vswitch.pod_1.id, alicloud_vswitch.pod_2.id]
  worker_instance_types = var.worker_instance_types
  worker_number         = var.worker_number
  install_cloud_monitor = true
  proxy_mode            = var.proxy_mode
  password              = var.node_login_password
  service_cidr          = var.service_cidr
  pod_cidr              = var.pod_cidr
  cluster_spec          = var.cluster_spec
  new_nat_gateway       = false
  version               = "1.18.8-aliyun.1"
  slb_internet_enabled  = false
  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }
}
