provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Made = "terraform"
    }
  }
}
