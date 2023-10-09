# AWS EC2 KMS

Implementing different KMS policies for EC2 instances.

To start the demo:

```sh
terraform init
terraform apply -auto-approve
```

Copy the `kms_key_id` output and connect to both instances.

Teste the commands on both EC2 instances:

```sh
aws kms describe-key --key-id <id>

aws kms encrypt \
    --key-id <id> \
    --plaintext $(echo  'hello' | base64) \
    --output text \
    --query CiphertextBlob | base64
```

Test the `kms:GenerateDataKey` action:

```sh
aws kms generate-data-key \
    --key-id <id>  \
    --key-spec AES_256
```

---

### Clean-up

```
terraform destroy -auto-approve
```
