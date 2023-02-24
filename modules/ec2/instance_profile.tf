locals {
  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}

resource "aws_iam_instance_profile" "task-cw" {
  name = "EC2-Profile"
  role = aws_iam_role.task-cw.name
}

resource "aws_iam_role_policy_attachment" "task-cw" {
  count = length(local.role_policy_arns)

  role       = aws_iam_role.task-cw.name
  policy_arn = element(local.role_policy_arns, count.index)
}

resource "aws_iam_role_policy" "task-cw" {
  name = "EC2-Inline-Policy"
  role = aws_iam_role.task-cw.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role" "task-cw" {
  name = "EC2-Role"
  path = "/"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow"
        }
      ]
    }
  )
}