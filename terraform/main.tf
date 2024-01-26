resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster"
}

# Associate the autoscaling group with the cluster's capacity provider
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "primary-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
    }
  }
}

# Bind autoscaling group capacity provider with ECS cluster
resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_cap_provider" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2

  network_configuration {
    subnets         = [aws_subnet.primary.id, aws_subnet.secondary.id]
    security_groups = [aws_security_group.security_group.id]
  }

  /*
  Enables redeployment on each apply.
  Useful when using tags like "latest" to force
  the fetch from the registry and deploy the change
  */
  force_new_deployment = true

  # run each task (container) on separate instance
  placement_constraints {
    type = "distinctInstance"
  }

  # TODO: read about this
  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    # Relative percentage of the total number of launched tasks that should use the specified capacity provider.
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "fe"
    container_port   = 3000
  }

  depends_on = [aws_autoscaling_group.ecs_asg]
}
