terraform {
  backend "s3" {
    bucket               = "ymtdzzz-terraform"
    workspace_key_prefix = "emojivoto-openteleemtry-sample"
    key                  = "emojivoto-openteleemtry-sample.tfstate"
    region               = "ap-northeast-1"
  }
}
