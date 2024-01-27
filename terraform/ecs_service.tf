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
