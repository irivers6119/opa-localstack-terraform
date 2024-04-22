module "kms" {
  source = "terraform-aws-modules/kms/aws"
  version = "1.3.0" 

  description         = "KMS key for encrypted bucket"
  enable_key_rotation = false
  create_external     = true
  key_usage           = "ENCRYPT_DECRYPT"

  # assign users to manage and use the key
  key_owners         = []
  key_administrators = []
  key_users          = []

  # each key can have multiple aliases with different permissions
  aliases                 = []
  aliases_use_name_prefix = true

  # assign grants to AWS resource to use this Key
  grants = {
    # keep reading
  }
}