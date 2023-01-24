terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      ManagedBy  = "Terraform"
      Repostiory = "aeirola/sukunimitin"
      Site       = "aeirola.github.io/sukunimitin/"
    }
  }
}

provider "aws" {
  alias  = "global"
  region = "us-east-1"

  default_tags {
    tags = {
      ManagedBy  = "Terraform"
      Repostiory = "aeirola/sukunimitin"
      Site       = "aeirola.github.io/sukunimitin/"
    }
  }
}
