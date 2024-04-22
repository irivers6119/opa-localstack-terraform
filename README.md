# Terraform Localstack, OPA, and Terraform

This repository contains Terraform configurations for deploying resources to Localstack and usa OPA

## Usage

To use this repository, follow these steps. It is assuming you have [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed, python, and pip. Additional dependencies are [jq](https://jqlang.github.io/jq/), [tree](https://www.npmjs.com/package/tree-cli), [node](https://nodejs.org/en), [npm](https://www.npmjs.com/), [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), [awsclilocal](https://github.com/localstack/awscli-local) :

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
  tflocal show -json tfplan.binary > tfplan10.json
  ```

That's it! You should now have your resources deployed to Localstack.

6. Install OPA binary or use Docker

# Install OPA binary

```bash
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod +x opa
sudo mv opa /usr/local/bin/

# Use Docker to install OPA
docker pull openpolicyagent/opa:latest
```

7. Execute OPA

```bash

opa eval --format pretty --data ./policy/enforce_s3_buckets_encryption.rego --input tfplan10.json "data.terraform.deny"
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

https://www.scalr.com/blog/opa-series-part-1-open-policy-agent-and-terraform

https://docs.aws.amazon.com/prescriptive-guidance/latest/saas-multitenant-api-access-authorization/opa.html

## License

This repository is licensed under the [MIT License](LICENSE).

