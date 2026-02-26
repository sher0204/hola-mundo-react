provider "aws" {
  region = "us-east-2"
}

variable "github_token" {
  type      = string
  sensitive = true
}

resource "aws_amplify_app" "app" {
  name        = "hola-mundo-react"
  repository  = "https://github.com/sher0204/hola-mundo-react"
  oauth_token = var.github_token

  build_spec = <<EOF
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - npm ci
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: dist
    files:
      - '**/*'
  cache:
    paths:
      - node_modules/**/*
EOF
}

# OJO: cambia "main" por "principal" si esa es tu rama real
resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.app.id
  branch_name = "main"
}