# balanced-infra

Balanced infrastructure definitions and tools.

## Building a new AMI

The `packer/` folder contains templates and scripts to build an AMI to use as
our base image. To build the image you need the validation key (`validation.pem`)
as well as the AWS certificate and key (`balanced-aws.crt` and `balanced-aws.key`,
ask Noah for these). Put all three of those in `packer/` folder and ensure your
`$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY` environment variables are set.

To verify everything is all set:

```bash
$ packer validate balanced-client.json
```

To start the build:

```bash
$ packer build balanced-client.json
```

After the build completes it will display the three (one for each region) AMI IDs.
Copy these into `https://github.com/balanced/confucius/blob/master/stacks/mapper.py#L28`.
