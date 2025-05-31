# Getting the policy (JSON) content - took from documentation
data "http" "ebs-csi-policy-json" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}


resource "aws_iam_policy" "ebs-csi-policy" {
  name        = "${var.ROLE_EBS_CSI_DRIVER}-policy"
  path        = "/"
  description = "This policy will give enough permisson to IRSA so that it can talk to EBS"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  depends_on = [ data.http.ebs-csi-policy-json ]
  policy = data.http.ebs-csi-policy-json.response_body
}


resource "aws_iam_role" "ebs-csi-role" {
  name = var.ROLE_EBS_CSI_DRIVER

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : var.EKS_OIDC_CONNECT_PROVIDER_ARN
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringEquals" : {
              "${var.EKS_OIDC_CONNECT_PROVIDER_ARN_EXTRACT}:sub" : "system:serviceaccount:${var.EBS_CSI_DRIVER_NAMESPACE}:${var.EBS_CSI_DRIVER_SA_NAME}"
            }
          }
        }
      ]
    }
  )

  tags = {
    Name = var.CLUSTER_ID
    env  = var.ENV
  }
}

resource "aws_iam_role_policy_attachment" "ebs-csi-policy-attachment" {
  role       = aws_iam_role.ebs-csi-role.name
  policy_arn = aws_iam_policy.ebs-csi-policy.arn
}


resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = var.CLUSTER_ID
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn  = "${aws_iam_role.ebs-csi-role.arn}"
}

