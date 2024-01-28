### Files overview:
  * `alb.tf` - contains Application Load Balancer infra setup for the Client.
  * `autoscaling_groups.tf` - defines two autoscaling groups - 1 for the service, 1 for the client, together with their launch templates.
  * `ecs_service.tf` - contains ECS services for the app client and service. It also provides the necessary resources and configurations for Service Connect (wip)
  * `ecs_tasks.tf` - defines the ECS tasks resources, used by the ECS services.
  * `main.tf` - holds the ECS cluster definition as well as two ECS capacity providers, used by the ECS services
  * `variables.tf` - some of the commonly used variables with their defaults and validation rules
  * `versions.tf` - specifies the AWS provider and the s3 + dynamodb backend for terraform
  * `vpc.tf` - holds the network configurations regarding VPC, subnets, IGW, routing tables, security group (too loose - wip)

In order to run the setup locally, one must set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` env vars.

To init the terraform setup - navigate to `/terraform` directory and run:
```sh
terraform init
```
To plan new infra changes - run:
```sh
terraform plan
```
To deploy the updated terraform setup - run:
```sh
terraform apply
```
