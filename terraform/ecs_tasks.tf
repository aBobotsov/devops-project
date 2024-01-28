resource "aws_ecs_task_definition" "ecs_fe_task_definition" {
  family             = "fe-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::100583038995:role/ecsTaskExecutionRole"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name         = "fe"
      image        = "abobotsov/devops-project-fe:${var.fe_image_tag}"
      memory       = 512
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          name          = "fe-port"
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "ecs_be_task_definition" {
  family             = "be-task"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::100583038995:role/ecsTaskExecutionRole"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name         = "be"
      image        = "abobotsov/devops-project-be:${var.be_image_tag}"
      memory       = 512
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          name          = "be-port"
          protocol      = "tcp"
        }
      ]
    }
  ])
}
