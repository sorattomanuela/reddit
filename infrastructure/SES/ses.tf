resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "this" {
  domain = var.domain
}

resource "aws_iam_role_policy_attachment" "instance-SES-full-access" {
  role       = var.instance_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}
