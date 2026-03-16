# locals {

#   name = "teste"

# }



module "ecr" {

  source = "terraform-aws-modules/ecr/aws"

  version = "2.1.0"



  repository_name = var.repository_name

  

  # Força deleção de repositórios com imagens

  force_delete = true



  repository_read_write_access_arns = ["arn:aws:iam::057096910794:role/LabRole"] # Trocar pelo LabRole

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