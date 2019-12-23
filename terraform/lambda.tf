resource "aws_iam_role" "handler_role" {
  name = "${var.app_name}_handler_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "handler_policy" {
  name = "${var.app_name}_handler_policy"
  role = "${aws_iam_role.handler_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.aws_default_region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": "kinesis:*",
            "Resource": "${aws_kinesis_stream.test_stream.arn}*"
        },
        {
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "${aws_dynamodb_table.test_table.arn}*"
        }
    ]
}
EOF
}

data "archive_file" "handler_zip" {
  type = "zip"
  source_dir = "../consumer"
  output_path = "function.zip"
}

resource "aws_lambda_function" "handler" {
  filename = "${data.archive_file.handler_zip.output_path}"
  function_name = "${var.app_name}_handler"
  role = "${aws_iam_role.handler_role.arn}"
  handler = "lambda_function.main"
  source_code_hash = "${data.archive_file.handler_zip.output_base64sha256}"
  runtime = "ruby2.5"
  memory_size = 128
  timeout = 600
  environment {
    variables = {
      DYNAMODB_TABLE = "${aws_dynamodb_table.test_table.name}"
    }
  }
}

resource "aws_lambda_event_source_mapping" "handler_trigger" {
  event_source_arn  = "${aws_kinesis_stream.test_stream.arn}"
  function_name = "${aws_lambda_function.handler.arn}"
  starting_position = "LATEST"
}
