# locals {
#   name = "teste"
# }

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version = "2.1.0"

  repository_name = var.repository_name

  #Force deletion of repository containing images
  repository_force_delete = true

  # Make repository mutable (allow overwriting tags)
  repository_image_tag_mutability = "MUTABLE"

  repository_read_write_access_arns = ["arn:aws:iam::${var.aws_account_id}:role/LabRole"] # LabRole para Academy
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

#   tags = {
#     locals.tags
#   }
}