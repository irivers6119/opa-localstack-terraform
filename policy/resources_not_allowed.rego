package terraform
 
import input as tfplan
 
# Allowed Terraform resources
allowed_resources = [
	"aws_security_group",
	"aws_instance",
	"aws_s3_bucket",
  "aws_kms_external_key",
  "aws_s3_bucket_ownership_controls",
  "aws_s3_bucket_public_access_block",
  "aws_s3_bucket_acl"
]
 
 
array_contains(arr, elem) {
	arr[_] = elem
}
 
deny[reason] {
  resource := tfplan.resource_changes[_]
  action := resource.change.actions[count(resource.change.actions) - 1]
  array_contains(["create", "update"], action)  # allow destroy action

  not array_contains(allowed_resources, resource.type)

  reason := sprintf(
    "%s: resource type %q is not allowed",
    [resource.address, resource.type]
  )
}