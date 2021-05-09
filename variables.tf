
variable "cluster_spec" {
  default = "ack.standard"
}

variable "k8s_name" {
}

variable "worker_instance_types" {
}

variable "worker_number" {
}

variable "proxy_mode" {
}

variable "node_login_password" {
}

variable "pod_cidr" {
}

variable "service_cidr" {
}

variable "cluster_addons" {
}

variable "region" {
  default = "cn-beijing"
}
