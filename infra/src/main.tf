data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.lambda.arn,
      "${aws_cloudwatch_log_group.lambda.arn}*"
    ]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name_prefix = "${var.lambda_function_name}_logging_"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role" "this" {
  name_prefix        = "${var.lambda_function_name}_logging_"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = var.source_file
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.this.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.this.arn
  handler          = var.function_handler_name
  source_code_hash = data.archive_file.this.output_base64sha256
  runtime          = "nodejs18.x"
  timeout          = 60
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function_url" "url" {
  function_name      = aws_lambda_function.this.arn
  invoke_mode        = "BUFFERED"
  authorization_type = "NONE"
}
