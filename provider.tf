terraform {
  cloud {
    organization = "my-DevSecOps-journey"

    workspaces {
      name = "AutomatedPros-TI-project2"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}