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
  - name: 'CloudFront Deploy'
      uses: apfm-actions/terraform-cloudfront-action@master
      with:
        comment: APFM CDN
        origin_domain_name: aplaceformom.com
        origin_id: apfm_origin
```


Inputs
-----

### destroy
Runs Terraform destroy to remove resources created by this action
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

### enable_cloudfront
Whether the distribution is enabled to accept end user requests for content
- required: false
- default: true

### comment
Any comments you want to include about the distribution
- required: true

### default_root_object
The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL
- required: false

### price_class
The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100
- required: false
- default: 'PriceClass_100'

### origin_domain_name
The DNS domain name of the web site for a custom origin or the S3 bucket name
- required: true

### origin_is_s3
Set to true if the origin is an S3 bucket, otherwise set to false and a custom origin will be used.
- required: false
- default: false

### origin_access_identity
The CloudFront origin access identity to associate with the origin. Only applicable to S3 origins
required: false

### origin_id
A unique identifier for the origin
- required: true

### origin_path
An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin
- required: false

### origin_http_port
The HTTP port the custom origin listens on. Only for custom origins
- required: false
- default: 80

### origin_https_port
The HTTPS port the custom origin listens on. Only for custom origins
- required: false
- default: 443

### origin_protocol_policy
The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer. Only for custom origins
- required: false
- default: 'https-only'

### origin_ssl_protocols
The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. A list of one or more of SSLv3, TLSv1, TLSv1.1, and TLSv1.2. Only for custom origins
- required: false
- default: 'TLSv1.2'

### allowed_methods
A comma separated list of Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin
- required: false
- default: 'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'

### cached_methods
Controls whether CloudFront caches the response to requests using the specified HTTP methods
- required: false
- default: 'GET,HEAD'

### default_ttl
The default amount of time (in seconds) that an object is in a CloudFront cache
- required: false
- default: 86400

### max_ttl
The maximum amount of time (in seconds) that an object is in a CloudFront cache
- required: false
- default: 31536000

### min_ttl
The minimum amount of time that you want objects to stay in CloudFront caches
- required: false
- default: 0

### viewer_protocol_policy
Use this element to specify the protocol that users can use to access the files in the origin. One of allow-all, https-only, or redirect-to-https
- required: false
- default: 'allow-all'

### forward_headers
Specifies the Headers, if any, that you want CloudFront to vary upon for this cache behavior
- required: false

### forward_query_string
Indicates whether you want CloudFront to forward query strings to the origin
- required: false
- default: false

### forward_cookies
Specifies whether you want CloudFront to forward cookies to the origin. You can specify all or none
- required: false
- default: 'none'

### domain_names
A comma separated list of domain name aliases for this CF distribution. The first domain name/alias will be the primary domain name, and the rest will be added as SANs in the issued certificate. If not defined, the default SSL certificate will be used
- required: false

### minimum_protocol_version
The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections
- required: false
- default: 'TLSv1.2_2018'

### restriction_locations
The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist)
- required: false

### locations_restriction_type
The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist
- required: false
- default: 'none'

### logging_bucket
The Amazon S3 bucket to store the access logs in
- required: false

### logging_include_cookies
Specifies whether you want CloudFront to include cookies in access logs
- required: false
- default: false

### logging_prefix
An optional string that you want CloudFront to prefix to the access log filenames for this distribution
- required: false


Outputs
-------

|         Context            |              Description                |
|----------------------------|-----------------------------------------|
| cloudfront_status          | The current status of the distribution  |
| cloudfront_domain_name     | The domain name corresponding to the distribution |



To Do
-------
- ISSUE: If CF is configured with a custom SSL certificate, and we want to switch to the default certificate instead, Terraform will have trouble deleting the SSL certificate because it is in use. To fix, we need to force CF to use the default certificate FIRST and then delete.
- Test S3 origins
