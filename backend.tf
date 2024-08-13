terraform {
  backend "s3" {
    bucket = "tf-backend-fullstack"
    key    = "terraform.tfstate"
    region = "us-east-1"
    workspace_key_prefix = "app"
  }
}
