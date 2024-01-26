resource "aws_autoscaling_group" "ecs_asg" {
  vpc_zone_identifier = [aws_subnet.primary.id, aws_subnet.secondary.id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix            = "ecs-template"
  image_id               = "ami-0d0b75c8c47ed0edf"
  instance_type          = var.fe_instance_type
  key_name               = "tf_key"
  vpc_security_group_ids = [aws_security_group.security_group.id]

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.instance_volume_size
      volume_type = var.instance_volume_type
      encrypted   = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = {
      name = "ecs-instance"
    }
  }

  # TODO: read about this
  user_data = filebase64("${path.module}/ecs.sh")
}
