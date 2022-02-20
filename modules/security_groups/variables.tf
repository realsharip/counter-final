variable "ports" {
  type = list(number)
}

variable "vpc_id" {
  type = string
  description = "Necessary for accepting value from root module"
}