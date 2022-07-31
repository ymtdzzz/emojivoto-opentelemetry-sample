resource "aws_ecs_cluster" "main" {
  name = var.app_name
}

resource "aws_ecs_task_definition" "main" {
  family = var.app_name
  container_definitions = templatefile("./ecs-task-definition.json", {
    emojisvc_host  = var.emojisvc_host
    votingsvc_host = var.votingsvc_host
    log_group      = "/ecs/${var.app_name}"
    log_region     = var.region
  })
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "main" {
  name    = var.app_name
  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  depends_on = [aws_alb_listener.main]

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "app"
    container_port   = 8080
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.fargate_service.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.app_name}-iam-role-ecs"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.app_name}"
}
