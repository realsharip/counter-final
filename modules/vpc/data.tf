# Data about region afterwards will be used by azs
data "aws_region" "current" {
  name = var.region
}

# Data about availability zones in current region
data "aws_availability_zones" "available" {
  state = "available"
}
