provider "alicloud" {
  # Configuration options
  region = var.region
}

provider "alicloud" {
  alias  = "memberprovider"
  region = var.region
}
