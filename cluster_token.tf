resource "random_password" "cluster_token" {
  length  = 30
  special = false
}
