resource "aws_sns_topic" "codepipeline_notifications" {
  name = "${local.task_name}-codepipeline-notify"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.codepipeline_notifications.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions = ["SNS:Publish"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codestar.amazonaws.com"]
    }
    resources = [aws_sns_topic.codepipeline_notifications.arn]
  }
}