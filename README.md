AWS Terraform Example Action
============================
This repository is home to an _example_ GitHub action used as a template for
rapid development of Terraform based actions. The goal of this model is to
provide a common framework for deploying modularized infrastructure with
configuration paramters supplied as part of the GitHub workflow.

Usage
-----
Simply clone this repository and start developing your Terraform IAC. The
entrypoint handler for this action will automatically translate GitHub inputs
into terraform variables.

For example, if your define the following `action.yaml`:
```yaml
name: Example
description: An example GitHub action
inputs:
  foo:
    description: An input named foo
  bar:
    description: An input named bar
```

Then you are able to use these inputs directly as Terraform varables:
```
resource "a_terraform_resource" "example" {
  paramter1 = var.foo
  paramter2 = var.bar
}
```


To Do
-------
- ISSUE: If CF is configured with a custom SSL certificate, and we want to switch to the default certificate instead, Terraform will have trouble deleting the SSL certificate because it is in use. To fix, we need to force CF to use the default certificate FIRST and then delete.
