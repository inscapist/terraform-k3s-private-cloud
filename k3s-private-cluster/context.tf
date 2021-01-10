module "this" {
  source  = "cloudposse/label/null"
  version = "0.22.1"

  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  delimiter   = var.delimiter
  tags        = var.tags
}
