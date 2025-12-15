terraform {
  backend "s3" {
    bucket         = "penja-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"  # Path in S3 where the state file will be stored
    region         = "us-west-2"
    encrypt        = true                           # Enables server-side encryption
    # dynamodb_table = "terraform-locks"      # Name of the DynamoDB table for state locking
  }
}


resource "null_resource" "test" {
  count=5
  triggers = {
    always_run = timestamp()
  }
}

variable "my_variable" {
  type        = string
  description = "Test string variable"
  default     = "sunshine"
}

variable "max_value" {
  type        = number
  description = "This is the maximum value of sunshine points"
  default     = 100
  sensitive   = true
}

variable "min_value" {
  type        = number
  description = "This is the minimum value of sunshine points test"
  default     = 5
  sensitive   = true
}

variable "is_bool" {
  type        = bool
  description = "This is bool var"
  default     = true
}

variable "available_types" {
  type    = list(string)
  default = ["Cozy", "Radiant", "Warm", "Playful", "Sparkling", "Lucky", "Joyful"]
}

resource "null_resource" "check_ip_and_variable" {
  triggers = {
    current_time = timestamp()
  }
  provisioner "local-exec" {
    command = "curl -s https://ifconfig.me/ip > ip.txt"
  }
}

resource "random_integer" "random_index" {
  min = 0
  max = length(var.available_types) - 1
}

resource "random_integer" "random_integer" {
  max = var.max_value
  min = var.min_value

  #  # Validation and error handling
  #  lifecycle {
  #    ignore_changes = [max, min]  # Ignore changes to max and min values
  #  }
}


output "scalr_ip_with_variables" {
  value = "Here is new commit, yay! Sunshine type is ${element(var.available_types, random_integer.random_index.result)} ${var.my_variable}\nCurrent time is ${timestamp()}\nYou get ${random_integer.random_integer.result} sunshine points.\nHave a great day!"
}
