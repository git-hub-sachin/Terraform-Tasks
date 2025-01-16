variable "vpc_id" {
  type = string
}


variable "ingress_rules" {
  type = object({
    name = string
    from_port = list(number)
    to_port = list(number)
    protocol = list(string)
    cidr_blocks = list(string)
  })
}


# variable "name" {
#   type = string
# }
# variable "from_port" {
#   type = number
# }
# variable "to_port" {
#   type = number
# }
# variable "protocol" {
#   type = string
# }
# variable "cidr_blocks" {
#   type = list(string)
# }