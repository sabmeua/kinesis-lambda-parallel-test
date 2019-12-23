resource "aws_kinesis_stream" "test_stream" {
  name = "${var.app_name}_stream"
  shard_count = 1
}
