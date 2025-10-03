resource "aws_flow_log" "tgw" {
  count                    = var.flow_logs ? 1 : 0
  iam_role_arn             = aws_iam_role.flow_logs[0].arn
  log_destination          = aws_cloudwatch_log_group.flow_logs[0].arn
  traffic_type             = "ALL"
  transit_gateway_id       = aws_ec2_transit_gateway.default[0].id
  max_aggregation_interval = 60

  tags = {
    "Name" = "${var.name}-tgw-flow-logs"
  }
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count             = var.flow_logs ? 1 : 0
  name              = "/aws/vpc/${var.name}-tgw/flow-logs"
  retention_in_days = var.flow_logs_retention
}

resource "aws_iam_role" "flow_logs" {
  count = var.flow_logs ? 1 : 0
  name  = "${var.name}-tgw-flow-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow_log" {
  count = var.flow_logs ? 1 : 0
  name  = "${var.name}-tgw-flow-logs-policy"
  role  = aws_iam_role.flow_logs[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
