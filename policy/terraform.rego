package terraform.localstack.policy

import rego.v1

import input as tfplan

########################
# Parameters for Policy
########################

# acceptable score for automated authorization
blast_radius := 30

# weights assigned for each operation on each resource-type
weights := {
	"aws_instance": {"delete": 0, "create": 2, "modify": 1},
}

# Consider exactly these resource types in calculations
resource_types := {"aws_instance", "aws_iam"}

#########
# Policy
#########

# Authorization holds if score for the plan is acceptable and no changes are made to IAM
default authz := false

authz if {
	score < blast_radius
	not touches_iam
}

# Compute the score for a Terraform plan as the weighted sum of deletions, creations, modifications
score := s if {
	all := [x |
		some resource_type
		crud := weights[resource_type]
		del := crud["delete"] * num_deletes[resource_type]
		new := crud["create"] * num_creates[resource_type]
		mod := crud["modify"] * num_modifies[resource_type]
		x := (del + new) + mod
	]
	s := sum(all)
}

# Whether there is any change to IAM
touches_iam if {
	all := resources.aws_iam
	count(all) > 0
}

####################
# Terraform Library
####################

# list of all resources of a given type
resources[resource_type] := all if {
	some resource_type
	resource_types[resource_type]
	all := [name |
		name := tfplan.resource_changes[_]
		name.type == resource_type
	]
}

# number of creations of resources of a given type
num_creates[resource_type] := num if {
	some resource_type
	resource_types[resource_type]
	all := resources[resource_type]
	creates := [res | res := all[_]; res.change.actions[_] == "create"]
	num := count(creates)
}

# number of deletions of resources of a given type
num_deletes[resource_type] := num if {
	some resource_type
	resource_types[resource_type]
	all := resources[resource_type]
	deletions := [res | res := all[_]; res.change.actions[_] == "delete"]
	num := count(deletions)
}

# number of modifications to resources of a given type
num_modifies[resource_type] := num if {
	some resource_type
	resource_types[resource_type]
	all := resources[resource_type]
	modifies := [res | res := all[_]; res.change.actions[_] == "update"]
	num := count(modifies)
}
