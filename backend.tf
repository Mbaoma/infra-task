terraform {
  backend "s3" {
    bucket = "infra-task"
    key    = "infra/infra-task.tfstate"
    region = "us-east-1"
  }
}
