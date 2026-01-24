# Hello World

> [!IMPORTANT]
> ### App name must be registered in the base configuration
>
> This demo **assumes the application name is pre-declared** in the Base module configuration.
>
> The `app_name` used by this module **must exist in the `app_names` array** defined in:
>
> ```
> demo/01-base/terraform.tfvars
> ```
>
> If the application name is missing, derived locals such as the SSM path prefix will resolve to `null`, which causes Terraform to fail during plan or apply with errors like:
>
> - Missing required argument for `aws_ssm_parameters_by_path`
> - Invalid template interpolation due to a `null` path prefix
>
> **Before running this demo**, ensure the application name is explicitly listed in the base configuration so all downstream paths, log groups, and secrets can be resolved correctly.
