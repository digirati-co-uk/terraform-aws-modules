# Bastion module

This is an EC2 instance that provides SSH access to private subnet(s). 

It will be provisioned with an ASG and will register itself with Route53 on startup.

## Parameters
The following parameters are available:

| Parameter                  | Description                                                   | Type   | Default                     |
| -------------------------- | ------------------------------------------------------------- | ------ | --------------------------- |
| ami                        | AMI to use                                                    | string | latest AL2023               |
| instance_type              | EC2 instance type                                             | string | t3a.micro                   |
| prefix                     | Prefix for AWS resources                                      | string |                             |
| key_name                   | EC2 key pair name to use                                      | string |                             |
| vpc                        | VPC to join                                                   | string |                             |
| ip_whitelist               | List of CIDR blocks to allow SSH access for                   | list   | []                          |
| subnets                    | VPC subnets to launch in                                      | string |                             |
| dns_zone                   | DNS Hosted Zone ID to create bastion record within            | string |                             |
| domain                     | Apex domain to use (e.g. dlcs.io)                             | string |                             |
| hostname                   | Hostname to register bastion record with. Prepended to domain | string | bastion                     |
| min_size                   | Minimum number of instances                                   | number | 1                           |
| max_size                   | Maximum number of instances                                   | number | 1                           |
| additional_security_groups | Additional security groups to assign                          | list   | []                          |
| cron_stop                  | cron schedule for when to stop Bastion host                   | string | 0 1 1 * *"                  |
| cron_start                 | cron schedule for when to start Bastion host                  | string | 30 1 1 * *"                 |
| host_key_ssm_path          | SSM path prefix storing the persistent SSH host key           | string | /{prefix}/bastion/host-keys |
| host_key_kms_key_id        | KMS key used to encrypt the stored host key                   | string | alias/aws/ssm               |

> [!NOTE]
> The default cron schedule will restart the Bastion host once per month
> This will ensure it is routinely updated (e.g. to use updated AMI that has been applied)

## SSH host key

By default, when a Bastion host is replaced the new instance will have a new SSH host key, resulting
in the `REMOTE HOST IDENTIFICATION HAS CHANGED` warning and needing to update `known_hosts`.

To avoid this, on first boot the host generates an `ed25519` host key and stores as a SSM
Parameter Store `SecureString`. Subsequent boots restore that key to have a stable identity.
The matching public key is stored alongside it as a plain `String` parameter (suffixed `.pub`).

This can be added to known_hosts before first connection using:

```bash
echo "bastion.example.com $(aws ssm get-parameter \
  --name /my-prefix/bastion/host-keys/ssh_host_ed25519_key.pub \
  --query Parameter.Value --output text)" >> ~/.ssh/known_hosts
```

Only an `ed25519` host key is offered - the RSA and ECDSA keys are removed on boot, so a stale
entry of those types cannot be negotiated and trigger a mismatch.

### Protecting the stored key

If `host_key_kms_key_id` isn't specified the secret will be created with the default KMS key.

> [!CAUTION]
> Storing the host key in SSM moves it from "root only on disk" to a parameter that any principal
> with broad SSM read access can fetch. `AmazonSSMManagedInstanceCore` grants
> `ssm:GetParameter` on `*`, so **every instance carrying that policy can read this key** when it
> is encrypted with the default `aws/ssm` key. This would allow any other EC2 host to use that key
> and impersonate bastion.

To limit access, set `host_key_kms_key_id` to a CMK. Broad `ssm:GetParameter` still returns the
parameter, but decryption fails for anything without an explicit KMS grant on that key. Example TF
to set up:

```hcl
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "bastion_host_key" {
  statement {
    sid       = "AllowAccountAdministration"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_kms_key" "bastion_host_key" {
  description             = "Encrypts the bastion SSH host key"
  policy                  = data.aws_iam_policy_document.bastion_host_key.json
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "bastion_host_key" {
  name          = "alias/my-prefix-bastion-host-key"
  target_key_id = aws_kms_key.bastion_host_key.key_id
}

module "bastion" {
  source = "../modules/bastion"
  prefix = "my-prefix"
  # ..other args..

  host_key_kms_key_id = aws_kms_key.bastion_host_key.arn
}
```

### Rotation

Setting `host_key_kms_key_id` on a Bastion that already stored a key has no effect on its own 
as the instance never overwrites an existing key.

To move it without changing the host identity, re-write it in place:

```bash
PARAM=/my-prefix/bastion/host-keys/ssh_host_ed25519_key
aws ssm put-parameter --name $PARAM --type SecureString --overwrite \
  --key-id alias/my-prefix-bastion-host-key \
  --value "$(aws ssm get-parameter --name $PARAM --with-decryption \
    --query Parameter.Value --output text)"
```

Alternatively just rotate the key by deleting both SSM parameters and terminating the instance.
The replacement will generate and store a new key.

## Outputs

| Parameter              | Description                                       | Type   |
| ---------------------- | ------------------------------------------------- | ------ |
| bastion_security_group | ID of the bastion's security group                | string |
| role                   | Name of the bastion's role                        | string |
| host_key_ssm_parameter | SSM parameter holding the persistent SSH host key | string |
