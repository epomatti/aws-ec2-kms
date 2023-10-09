# AWS EC2 KMS

Implementing different KMS policies for EC2 instances.

To start the demo:

```sh
terraform init
terraform apply -auto-approve
```

Copy the `kms_key_id` output and connect to both instances.

The KMS key policy allows c

```sh
aws kms describe-key --key-id <id>
```
