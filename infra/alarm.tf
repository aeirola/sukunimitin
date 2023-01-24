resource "aws_sns_topic" "alarms" {
  provider = aws.global

  name         = "aeirola-sukunimitin-alarms"
  display_name = "aeirola-sukunimitin alarms"
}

resource "aws_sns_topic_subscription" "alarms" {
  provider = aws.global

  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = "axel@havukangas.fi"
}


resource "aws_cloudwatch_metric_alarm" "cloudfront_error_rate" {
  provider = aws.global

  alarm_name        = "Sukunimitin cloudfront error rate"
  alarm_description = "Triggers if the sukunimitin CORS proxy receives a lot of errors."

  namespace   = "AWS/CloudFront"
  metric_name = "TotalErrorRate"
  dimensions  = { DistributionId = aws_cloudfront_distribution.this.id }

  period             = 300
  statistic          = "Average"
  evaluation_periods = 1

  comparison_operator = "GreaterThanThreshold"
  threshold           = 0

  alarm_actions = [aws_sns_topic.alarms.arn]
}
