resource "aws_autoscaling_group" "ecs_fe_asg" {
  vpc_zone_identifier = [aws_subnet.primary.id, aws_subnet.secondary.id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.ecs_fe_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "ecs_fe_lt" {
  name_prefix            = "ecs-template"
  image_id               = var.ecs_optimised_ami
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

  user_data = filebase64("${path.module}/ecs.sh")
}

resource "aws_autoscaling_group" "ecs_be_asg" {
  vpc_zone_identifier = [aws_subnet.primary.id, aws_subnet.secondary.id]
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.ecs_be_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "ecs_be_lt" {
  name_prefix            = "ecs-template"
  image_id               = var.ecs_optimised_ami
  instance_type          = var.be_instance_type
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

  user_data = filebase64("${path.module}/ecs.sh")
}

