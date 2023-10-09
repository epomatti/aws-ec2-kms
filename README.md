# AWS EC2 KMS

Implementing different KMS policies for EC2 instances.

To start the demo:

```sh
terraform init
terraform apply -auto-approve
```

The KMS Key has the following key policy:

```json
{
    "Version": "2012-10-17",
    "Id": "EC2Project",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::000000000000:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::000000000000:role/EC2RoleA",
                    "arn:aws:iam::000000000000:role/EC2RoleB"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
```

`EC2RoleA` has no policies, but `EC2RoleB` has the inline policy:

```json
{
  "Statement": [
    {
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:DescribeKey"
      ],
      "Effect": "Deny",
      "Resource": "*",
      "Sid": "VisualEditor0"
    }
  ],
  "Version": "2012-10-17"
}
```

Now for the testing, copy the `kms_key_id` output and connect to both instances.

Run the commands on both EC2 instances:

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
