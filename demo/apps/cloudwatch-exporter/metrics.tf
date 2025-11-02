module "log_metrics" {
  source = "../../../../modules/metrics"

  metrics_config = {
    account_id      = local.account_id
    log_group_names = [
      "/aws/lambda/ask_copilot"
    ]
  }
}
