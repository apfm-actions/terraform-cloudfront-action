CloudFront Terraform Action
============================
Deploy an AWS CloudFront using Terraform.


Caveats
-----

- When using a custom SSL Certificate, the first deployment will fail because the SSL certificate domain validation has not been completed; therefore, the SSL cert will not be valid/issued. Domain validation must be done manually via DNS.
- Terraform Project Action must be executed before this action  
https://github.com/aplaceformom/terraform-project-base-action


Usage
-----

```yaml
  - name: 'DocumentDB Deploy'
      uses: aplaceformom/terraform-docdb-action@master
      with:
        cluster_name: example
        username: example_admin
        credstash_docdb_password: example_credstash_key
        subnet_ids: ${{ steps.project.outputs.subnet_id_private }}
        instance_count: 2
```


Inputs
-----

### destroy
Runs Terraform destroy to remove resources created by this action'
- required: false
- default: false

### deploy
Runs Terraform apply to create/update resources created by this action
- required: false
- default: true

### plan
Runs Terraform plan to check the changes necessary to achieve the desired state
- required: false
- default: true



Outputs
-------

|         Context            |              Description                |
|----------------------------|-----------------------------------------|
| cloudfront_status          | The current status of the distribution  |
| cloudfront_domain_name     | The domain name corresponding to the distribution |



To Do
-------
- complete readme
- ISSUE: If CF is configured with a custom SSL certificate, and we want to switch to the default certificate instead, Terraform will have trouble deleting the SSL certificate because it is in use. To fix, we need to force CF to use the default certificate FIRST and then delete.
- Enable S3 origins
