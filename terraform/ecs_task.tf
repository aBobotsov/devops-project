resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "service"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::100583038995:role/ecsTaskExecutionRole"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name         = "fe"
      image        = "abobotsov/devops-project-fe:sha-38004413d738e69aba1db0aec848166865dfe785"
      memory       = 512
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}
