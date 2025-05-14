terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0" # Or whatever latest version you want to use
    }
  }

  required_version = ">= 1.0.0" # Optional, depending on your Terraform CLI version
}

provider "aws" {
  region = var.aws_region
}
module "eventbridge" {
  source = "./modules/eventbridge"
  #sqs_queues = module.sqs.sqs_queues
  event_bus_name = var.event_bus_name
}

module "lambda" {
  source               = "./modules/lambda"
  event_bus_arn        = module.eventbridge.event_bus_arn
  lambda_runtime       = var.lambda_runtime
  lambda_function_name = var.lambda_function_name

}

module "api_gateway" {
  source = "./modules/api_gateway"
  #lambda_function_arn = module.lambda.lambda_function_arn
  api_gateway_stage_name = var.api_gateway_stage_name
  lambda_invoke_arn      = module.lambda.invoke_arn
  lambda_function_name   = module.lambda.function_name
}
