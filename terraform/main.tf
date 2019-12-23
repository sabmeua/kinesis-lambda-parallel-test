variable "app_name" {
  type = "string"
  default = "kinesis_parallel_test"
}

variable "app_env" {
  type = "string"
  default = "devel"
}

variable "aws_profile" {}
variable "aws_default_region" {}

provider "aws" {
  profile = "${var.aws_profile}"
  region = "${var.aws_default_region}"
}

data "aws_caller_identity" "current" {}
