# Declaration
variable s3_bucket_name { 
    default = "s3-tfs-gb-st-01"
    type = string
    description = "for terraform state locking"
}

variable ddb_name { 
    default = "ddb-tfl-gb-st-01"
    type = string
    description = "for terraform state locking"
}

variable "regions" {
  type = map
  default = {
    "singapore" = "ap-southeast-1"
    "sydney" = "ap-southeast-2"
    "jakarta" = "ap-southeast-3"
  }
}

variable key_path {
    default = "global/s3/terraform.tfstate"
    type = string
    description = "s3 path for terraform state files"
}