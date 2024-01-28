resource "aws_ecs_service" "ecs_fe_service" {
  name            = "ecs-fe-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_fe_task_definition.arn
  desired_count   = 2

  network_configuration {
    subnets         = [aws_subnet.primary.id, aws_subnet.secondary.id]
    security_groups = [aws_security_group.security_group.id]
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.fe.arn
    container_name = "fe"
    container_port = 3000
  }


  /*
  Enables redeployment on each apply.
  Useful when using tags like "latest" to force
  the fetch from the registry and deploy the change
  */
  #  force_new_deployment = true

  # run each task (container) on separate instance
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider_fe.name
    # Relative percentage of the total number of launched tasks that should use the specified capacity provider.
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "fe"
    container_port   = 3000
  }

  # wait for the autoscaling group before registering tasks
  depends_on = [aws_autoscaling_group.ecs_fe_asg]
}

resource "aws_ecs_service" "ecs_be_service" {
  name            = "ecs-be-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_be_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.primary.id, aws_subnet.secondary.id]
    security_groups = [aws_security_group.security_group.id]
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.be.arn
    container_name = "be"
    container_port = 5000
  }

  /*
  Enables redeployment on each apply.
  Useful when using tags like "latest" to force
  the fetch from the registry and deploy the change
  */
  #  force_new_deployment = true

  # run each task (container) on separate instance
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider_be.name
    # Relative percentage of the total number of launched tasks that should use the specified capacity provider.
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "be"
    container_port   = 5000
  }

  # wait for the autoscaling group before registering tasks
  depends_on = [aws_autoscaling_group.ecs_be_asg]
}

# Private service discovery
resource "aws_service_discovery_private_dns_namespace" "private" {
  name        = "demo"
  description = "Private dns namespace for service discovery"
  vpc         = aws_vpc.vpc.id
}

resource "aws_service_discovery_service" "fe" {
  name = "fe-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private.id

    dns_records {
      ttl  = 300
      type = "A"
    }

    dns_records {
      ttl  = 300
      type = "SRV"
    }
  }
}

resource "aws_service_discovery_service" "be" {
  name = "be-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private.id

    dns_records {
      ttl  = 300
      type = "A"
    }

    dns_records {
      ttl  = 300
      type = "SRV"
    }
  }
}
