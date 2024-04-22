# Terraform Localstack, OPA, and Terraform

This repository contains Terraform configurations for deploying resources to Localstack and usa OPA

## Usage

To use this repository, follow these steps:

1. Clone the repository:

  ```bash
  git clone https://github.com/irivers6119/localstack.git
  ```

2. Change into the repository directory:

  ```bash
  cd localstack
  ```

3. Install the required dependencies:

  ```bash
  tflocal init
  ```

4. Configure the Localstack endpoint:

  ```bash
  export AWS_DEFAULT_REGION=us-east-1
  export AWS_DEFAULT_OUTPUT=json
  export AWS_ENDPOINT_URL=http://localhost:4566
  ```

5. Apply the Terraform configurations:

  ```bash
  tflocal plan --out tfplan.binary
  tflocal 
  tflocal apply
  ```

That's it! You should now have your resources deployed to Localstack.

6. Install OPA binary or use Docker

7. Execute OPA

```bash

opa eval --format pretty --data policy.rego --input input.json "data.example.allow"
```
or

```bash
opa exec --decision terraform/deny --bundle policy/ tfplan10.json
```

# Output

#### All files in the policy folder are evaluated

```bash
{
  "result": [
    {
      "path": "tfplan10.json",
      "result": [
        "aws_s3_bucket.bucket: ACL \"private\" is not allowed",
        "aws_s3_bucket.bucket: expected sse_algorithm to be one of [\"AES256\"]"
      ]
    }
  ]
}
```


## Resources

https://www.env0.com/blog/open-policy-agent

https://www.openpolicyagent.org/docs/latest/terraform/

https://github.com/ned1313/learning-opa-and-terraform/tree/main

https://github.com/Scalr/sample-tf-opa-policies/tree/master

https://github.com/localstack/terraform-local

https://www.localstack.cloud/

https://hub.docker.com/extensions/localstack/localstack-docker-desktop

https://github.com/localstack/awscli-local


## License

This repository is licensed under the [MIT License](LICENSE).

