#   Create VPC
module "VPC" {
  source           = "../module/VPC"
  REGION           = var.REGION
  PROJECT_NAME     = var.PROJECT_NAME
  VPC_CIDR         = var.VPC_CIDR
  PUB_SUB_1_A_CIDR = var.PUB_SUB_1_A_CIDR
  PUB_SUB_2_B_CIDR = var.PUB_SUB_2_B_CIDR
  PRI_SUB_3_A_CIDR = var.PRI_SUB_3_A_CIDR
  PRI_SUB_4_B_CIDR = var.PRI_SUB_4_B_CIDR

}

#   Create IAM Roles with required permission
module "IAM" {
  source       = "../module/IAM"
  PROJECT_NAME = module.VPC.PROJECT_NAME
  ENV          = var.PROJECT_NAME
}

#   Create EKS Cluster + NodeGroup
module "EKS" {
  source                          = "../module/EKS"
  PROJECT_NAME                    = module.VPC.PROJECT_NAME
  EKS_MAIN_ROLE_ARN               = module.IAM.EKS_MAIN_ROLE_ARN
  ENV                             = var.ENV
  REGION                          = var.REGION
  CLUSTER_VERSION                 = var.CLUSTER_VERSION
  PUB_SUB_1_A_ID                  = module.VPC.PUB_SUB_1_A_ID
  PUB_SUB_2_B_ID                  = module.VPC.PUB_SUB_2_B_ID
  PRI_SUB_3_A_ID                  = module.VPC.PRI_SUB_3_A_ID
  PRI_SUB_4_B_ID                  = module.VPC.PRI_SUB_4_B_ID
  CLUSTER_ENDPOINT_PRIVATE_ACCESS = var.CLUSTER_ENDPOINT_PRIVATE_ACCESS
  CLUSTER_ENDPOINT_PUBLIC_ACCESS  = var.CLUSTER_ENDPOINT_PUBLIC_ACCESS
  CLUSTER_ENDPOINT_ACCESS_CIDR    = var.CLUSTER_ENDPOINT_ACCESS_CIDR
  CLUSTER_SVC_CIDR                = var.CLUSTER_SVC_CIDR
  EKS_MAIN_NODEGROUP_ROLE_ARN     = module.IAM.EKS_MAIN_NODEGROUP_ROLE_ARN
  INSTANCE_TYPE                   = var.INSTANCE_TYPE
  AMI_TYPE                        = var.AMI_TYPE
  NODE_CAPACITY_TYPE              = var.NODE_CAPACITY_TYPE
  NODE_DISK_SIZE                  = var.NODE_DISK_SIZE
  MAX_NODE                        = var.MAX_NODE
  MIN_NODE                        = var.MIN_NODE
  DESIRED_NODE                    = var.DESIRED_NODE
  # SSH_KEY_TO_ACCESS_NODE          = var.SSH_KEY_TO_ACCESS_NODE

}

#   Deploy VPC-CNI Addon
module "IAM_VPC_CNI" {
  depends_on                            = [module.EKS]
  source                                = "../module/tools/VPC-CNI"
  ENV                                   = var.ENV
  CLUSTER_ID                            = module.EKS.CLUSTER_ID
  EKS_OIDC_CONNECT_PROVIDER_ARN         = module.EKS.EKS_OIDC_CONNECT_PROVIDER_ARN
  EKS_OIDC_CONNECT_PROVIDER_ARN_EXTRACT = module.EKS.EKS_OIDC_CONNECT_PROVIDER_ARN_EXTRACT
  ROLE_VPC_CNI                          = var.ROLE_VPC_CNI
  VPC_CNI_NAMESPACE                     = var.VPC_CNI_NAMESPACE
  VPC_CNI_SA_NAME                       = var.VPC_CNI_SA_NAME
}

/*
#   Deploy Metrics server
module "METRICS_SERVER" {
  depends_on                      = [module.IAM_VPC_CNI]
  source                          = "../module/tools/Metrics_server"
  METRICS_SERVER_DRIVER_NAMESPACE = var.METRICS_SERVER_DRIVER_NAMESPACE
  METRICS_SERVER_DRIVER_SA_NAME   = var.METRICS_SERVER_DRIVER_SA_NAME
}
*/

#   Deploy EBS CSI Driver
module "IAM_EBS_CSI" {
  depends_on                            = [module.IAM_VPC_CNI]
  source                                = "../module/tools/EBS-IRSA"
  ENV                                   = var.ENV
  CLUSTER_ID                            = module.EKS.CLUSTER_ID
  EKS_OIDC_CONNECT_PROVIDER_ARN         = module.EKS.EKS_OIDC_CONNECT_PROVIDER_ARN
  EKS_OIDC_CONNECT_PROVIDER_ARN_EXTRACT = module.EKS.EKS_OIDC_CONNECT_PROVIDER_ARN_EXTRACT
  ROLE_EBS_CSI_DRIVER                   = var.ROLE_EBS_CSI_DRIVER
  EBS_CSI_DRIVER_NAMESPACE              = var.EBS_CSI_DRIVER_NAMESPACE
  EBS_CSI_DRIVER_SA_NAME                = var.EBS_CSI_DRIVER_SA_NAME
}
