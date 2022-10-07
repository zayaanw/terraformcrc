terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "zayaan"

    workspaces {
      name = "cloudresume"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


#Polices & Roles

data "aws_iam_policy" "dynamodbpolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/* resource "aws_iam_role_policy_attachment" "attach-dynamodb" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.dynamodbpolicy.arn
}  */

// #Lambda & DynamoDB 

/*  resource "aws_lambda_function" "Visitor_Lambda" {
  filename      = "lambda_function_payload_new.zip"
  function_name = "terraformlambda"
  role          = aws_iam_role.iam_for_lambda.arn

  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"
} */

resource "aws_dynamodb_table" "terraformdynamo" {
  name         = "SiteCounter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "websitestats"

  attribute {
    name = "websitestats"
    type = "S"
  }
}

/* #API Gateway

resource "aws_api_gateway_rest_api" "api" {
  name        = "api"
  description = "API for Cloud Resume Challenge"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "resource"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Visitor_Lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true } 
}
 */
/* # Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Visitor_Lambda.function_name
  principal     = "apigateway.amazonaws.com"

} */

#Gateway/Deployment

/* resource "aws_api_gateway_deployment" "gatewaydeploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource.id,
      aws_api_gateway_method.method.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "gwstage" {
  deployment_id = aws_api_gateway_deployment.gatewaydeploy.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "CRCPROD"
}  */