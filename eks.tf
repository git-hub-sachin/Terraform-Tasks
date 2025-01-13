module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    cluster_name    = "nandu-enterprise-eks"
    cluster_version = "1.31"
    subnet_ids =module.vpc.private_subnets
    vpc_id = module.vpc.vpc_id

    tags = {
        cluster="nandu-cluster"
    }

    eks_managed_node_group_defaults = {
        ami_type               = "AL2023_x86_64_STANDARD"
        instance_types         = ["t3.medium"]
    }

    eks_managed_node_groups = {
        node_group = {
        min_size     = 2
        desired_size = 2
        max_size     = 3
        }
    }
}