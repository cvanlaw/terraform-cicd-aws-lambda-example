variable "source_file" {
  type        = string
  description = "(optional) The path to the source file for this lambda."
  default     = "../../lambda/dist"
}

variable "lambda_function_name" {
  type        = string
  description = "(optional) The name of the lambda function to create."
  default     = "cicd-example"
}

variable "function_handler_name" {
  type        = string
  description = "(optional) The name of the function handler."
  default     = "app.handler"
}
