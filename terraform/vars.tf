variable "account_prefix" {
  type = string
  description = "Prefix for the resources."
}

variable "whitelisted_cidrs" {
  type = list(string)
  description = "Whitelisted CIDRs"
}

variable "userdata_gitlab_auth" {
  type = string
  description = "GitLab token to clone the repo. Must be of the form `username:token`."
}

variable "userdata_cpk_tf_bot_access_key_id" {
  type = string
  description = "AWS_ACCESS_KEY_ID of the cpk-tf-bot user."
}

variable "userdata_cpk_tf_bot_secret_access_key" {
  type = string
  description = "AWS_SECRET_ACCESS_KEY of the cpk-tf-bot user."
}

variable "userdata_target_role_arn" {
  type = string
  description = "ARN of the targeted role."
}
