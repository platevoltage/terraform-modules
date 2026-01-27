### AWS Resources

| Name | Type | Description |
|-----|-----|-------------|
| aws_cloudwatch_log_group.fargate_task_log_group | resource | Encrypted log group (inside ../../../modules/ecs-service) |
| aws_cloudwatch_metric_alarm.unhealthy_instance_count | resource | (inside ../../../modules/tg-fargate) |
| aws_codebuild_project.build | resource | (inside ../../../modules/codepipeline) |
| aws_codebuild_project.deploy | resource | (inside ../../../modules/codepipeline) |
| aws_codedeploy_app.ecs | resource | (inside ../../../modules/ecs-service) |
| aws_codedeploy_deployment_group.ecs | resource | (inside ../../../modules/ecs-service) |
| aws_codepipeline.codepipeline | resource | (inside ../../../modules/codepipeline) |
| aws_codestarconnections_connection.github_connection | resource | (inside ../../../modules/codepipeline) |
| aws_ecs_service.ecs_app_service_codedeploy | resource | CODE_DEPLOY controlled service for blue/green (inside ../../../modules/ecs-service) |
| aws_ecs_service.ecs_app_service_rolling | resource | } ROLLING service (inside ../../../modules/ecs-service) |
| aws_ecs_task_definition.app | resource | (inside ../../../modules/ecs-service) |
| aws_iam_policy.ecs_exec_policy | resource | ECS Exec policy (inside ../../../modules/ecs-service) |
| aws_iam_policy.secrets_manager_policy | resource | Example: attach a Secrets Manager policy so this task can read secrets: (inside ../../../modules/ecs-service) |
| aws_iam_policy.sqs_policy | resource | Example SQS policy (inside ../../../modules/ecs-service) |
| aws_iam_role.code_build_role | resource | (inside ../../../modules/codepipeline) |
| aws_iam_role.codedeploy | resource | (inside ../../../modules/ecs-service) |
| aws_iam_role.codepipeline_role | resource | (inside ../../../modules/codepipeline) |
| aws_iam_role.ecs_task_role | resource | ###################### IAM Role for the Task ###################### (inside ../../../modules/ecs-service) |
| aws_iam_role.replication | resource | (inside ../../../modules/codepipeline) |
| aws_iam_role_policy.codebuild_role_policy | resource | (inside ../../../modules/codepipeline) |
| aws_iam_role_policy.codepipeline_role_policy | resource | (inside ../../../modules/codepipeline) |
| aws_iam_role_policy.replication | resource | (inside ../../../modules/codepipeline) |
| aws_iam_role_policy_attachment.codedeploy_managed | resource | (inside ../../../modules/ecs-service) |
| aws_iam_role_policy_attachment.ecs_exec_policy_attachment | resource | (inside ../../../modules/ecs-service) |
| aws_iam_role_policy_attachment.secrets_manager_policy_attachment | resource | (inside ../../../modules/ecs-service) |
| aws_iam_role_policy_attachment.sqs_policy_attachment | resource | (inside ../../../modules/ecs-service) |
| aws_kms_alias.cloudwatch_logs | resource | (inside ../../../modules/ecs-service) |
| aws_kms_alias.s3kmskey | resource | (inside ../../../modules/codepipeline) |
| aws_kms_alias.s3kmskey_replica | resource | (inside ../../../modules/codepipeline) |
| aws_kms_alias.sns_topic | resource |  |
| aws_kms_key.cloudwatch_logs | resource | ###################### CloudWatch Log Group (KMS-encrypted) ###################### KMS key for CloudWatch Logs (inside ../../../modules/ecs-service) |
| aws_kms_key.s3kmskey | resource | KMS key for S3 bucket encryption (inside ../../../modules/codepipeline) |
| aws_kms_key.s3kmskey_replica | resource | KMS key for S3 replica bucket encryption (inside ../../../modules/codepipeline) |
| aws_kms_key.sns_topic | resource | CMK for SNS topic encryption |
| aws_lb_listener.test_8080 | resource | HTTPS test listener for CodeDeploy test traffic |
| aws_lb_listener_rule.host | resource | (inside ../../../modules/tg-fargate) |
| aws_lb_target_group.this | resource | (inside ../../../modules/tg-fargate) |
| aws_s3_bucket.codepipeline_access_logs | resource | Server access logging target for the artifact bucket (inside ../../../modules/codepipeline) |
| aws_s3_bucket.codepipeline_access_logs_replica | resource | ########################################### Access-logs bucket replica ########################################### (inside ../../../modules/codepipeline) |
| aws_s3_bucket.codepipeline_access_logs_replica_dst | resource | ########################################### Secondary logs bucket in replica region (dst) KMS encrypted and replicated back to primary ########################################### (inside ../../../modules/codepipeline) |
| aws_s3_bucket.codepipeline_access_logs_replica_dst_primary | resource | ########################################### Primary target for dst replication ########################################### (inside ../../../modules/codepipeline) |
| aws_s3_bucket.codepipeline_bucket | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket.codepipeline_bucket_replica | resource | ########################################### Artifact bucket replica ########################################### (inside ../../../modules/codepipeline) |
| aws_s3_bucket_lifecycle_configuration.codepipeline_access_logs | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_lifecycle_configuration.codepipeline_access_logs_replica | resource | Lifecycle for access-logs bucket replica (inside ../../../modules/codepipeline) |
| aws_s3_bucket_lifecycle_configuration.codepipeline_access_logs_replica_dst | resource | Lifecycle for dst logs bucket in replica region (inside ../../../modules/codepipeline) |
| aws_s3_bucket_lifecycle_configuration.codepipeline_access_logs_replica_dst_primary | resource | Lifecycle for primary bucket that receives dst replication (inside ../../../modules/codepipeline) |
| aws_s3_bucket_lifecycle_configuration.codepipeline_bucket | resource | Lifecycle (inside ../../../modules/codepipeline) |
| aws_s3_bucket_lifecycle_configuration.codepipeline_bucket_replica | resource | Lifecycle for artifact bucket replica (inside ../../../modules/codepipeline) |
| aws_s3_bucket_logging.codepipeline_access_logs_replica | resource | Logs replica -> dst bucket (inside ../../../modules/codepipeline) |
| aws_s3_bucket_logging.codepipeline_access_logs_replica_dst_primary | resource | Enable server access logging on the primary dst bucket (inside ../../../modules/codepipeline) |
| aws_s3_bucket_logging.codepipeline_bucket | resource | Access logging (inside ../../../modules/codepipeline) |
| aws_s3_bucket_logging.codepipeline_bucket_replica | resource | ########################################### Enable server access logging in replica ########################################### Artifact replica -> logs replica (inside ../../../modules/codepipeline) |
| aws_s3_bucket_notification.codepipeline_access_logs_eventbridge | resource | Event notifications via EventBridge for the access-logs bucket (inside ../../../modules/codepipeline) |
| aws_s3_bucket_notification.codepipeline_access_logs_replica_dst_eventbridge | resource | Event notifications for the dst logs bucket in replica region (inside ../../../modules/codepipeline) |
| aws_s3_bucket_notification.codepipeline_access_logs_replica_dst_primary_eventbridge | resource | Event notifications for the primary bucket that receives dst replication (inside ../../../modules/codepipeline) |
| aws_s3_bucket_notification.codepipeline_access_logs_replica_eventbridge | resource | Event notifications for the access-logs replica bucket (inside ../../../modules/codepipeline) |
| aws_s3_bucket_notification.codepipeline_bucket_eventbridge | resource | Event notifications via EventBridge (inside ../../../modules/codepipeline) |
| aws_s3_bucket_notification.codepipeline_bucket_replica_eventbridge | resource | Event notifications for the artifact replica bucket (inside ../../../modules/codepipeline) |
| aws_s3_bucket_ownership_controls.codepipeline_access_logs | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_ownership_controls.codepipeline_access_logs_replica | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_ownership_controls.codepipeline_access_logs_replica_dst | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_ownership_controls.codepipeline_access_logs_replica_dst_primary | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_ownership_controls.codepipeline_bucket | resource | Ownership + PAB for artifact bucket (inside ../../../modules/codepipeline) |
| aws_s3_bucket_ownership_controls.codepipeline_bucket_replica | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_policy.codepipeline_access_logs | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_policy.codepipeline_access_logs_replica | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_policy.codepipeline_access_logs_replica_dst | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_public_access_block.codepipeline_access_logs | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_public_access_block.codepipeline_access_logs_replica | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_public_access_block.codepipeline_access_logs_replica_dst | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_public_access_block.codepipeline_access_logs_replica_dst_primary | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_public_access_block.codepipeline_bucket | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_public_access_block.codepipeline_bucket_replica | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_replication_configuration.codepipeline_access_logs | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_replication_configuration.codepipeline_access_logs_replica_dst | resource | New: replicate the dst bucket back to primary to satisfy CKV_AWS_144 (inside ../../../modules/codepipeline) |
| aws_s3_bucket_replication_configuration.codepipeline_bucket | resource | ########################################### Replication configurations ########################################### (inside ../../../modules/codepipeline) |
| aws_s3_bucket_server_side_encryption_configuration.codepipeline_access_logs | resource | CKV_AWS_145 fix: use KMS for access logs bucket (inside ../../../modules/codepipeline) |
| aws_s3_bucket_server_side_encryption_configuration.codepipeline_access_logs_replica | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_server_side_encryption_configuration.codepipeline_access_logs_replica_dst | resource | KMS encryption to satisfy CKV_AWS_145 (inside ../../../modules/codepipeline) |
| aws_s3_bucket_server_side_encryption_configuration.codepipeline_access_logs_replica_dst_primary | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_server_side_encryption_configuration.codepipeline_bucket | resource | KMS-SSE with your key (inside ../../../modules/codepipeline) |
| aws_s3_bucket_server_side_encryption_configuration.codepipeline_bucket_replica | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_versioning.codepipeline_access_logs | resource | Versioning for access-logs bucket (CKV_AWS_21) (inside ../../../modules/codepipeline) |
| aws_s3_bucket_versioning.codepipeline_access_logs_replica | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_versioning.codepipeline_access_logs_replica_dst | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_versioning.codepipeline_access_logs_replica_dst_primary | resource | (inside ../../../modules/codepipeline) |
| aws_s3_bucket_versioning.codepipeline_bucket | resource | Versioning (inside ../../../modules/codepipeline) |
| aws_s3_bucket_versioning.codepipeline_bucket_replica | resource | (inside ../../../modules/codepipeline) |
| aws_security_group.ecs_fargate_task | resource | ECS Fargate task security group (inside ../../../modules/ecs-service) |
| aws_security_group_rule.ecs_fargate_task_egress | resource | ECS Fargate task Egress (inside ../../../modules/ecs-service) |
| aws_security_group_rule.ecs_fargate_task_egress_v6 | resource | ECS Fargate task Egress (inside ../../../modules/ecs-service) |
| aws_security_group_rule.from_alb_to_task | resource | Allow ALB to reach app port (inside ../../../modules/ecs-service) |
| aws_sns_topic.codepipeline_notifications | resource | Encrypted SNS topic |
| aws_sns_topic_policy.default | resource |  |
| module.codepipeline | module |  |
| module.ecs_service | module |  |
| module.target_group | module |  |
| module.target_group_green | module | Green target group only when blue_green |

## Data Sources

| Name | Type | Description |
|-----|-----|-------------|
| data.aws_caller_identity.current | data source |  |
| data.aws_iam_policy_document.codebuild_assume_role | data source | (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.codebuild_policy_document | data source | (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.codedeploy_assume | data source | IAM role for CodeDeploy (trusts codedeploy.amazonaws.com) (inside ../../../modules/ecs-service) |
| data.aws_iam_policy_document.codepipeline_access_logs_policy | data source | Allow S3 server access logs to write into target bucket (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.codepipeline_access_logs_replica_dst_policy | data source | Allow server access logs to write into the dst bucket (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.codepipeline_access_logs_replica_policy | data source | Allow server access logs writer in replica region (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.codepipeline_assume_role | data source | (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.codepipeline_policy | data source | (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.ecs_task_role_policy | data source | (inside ../../../modules/ecs-service) |
| data.aws_iam_policy_document.replication_assume | data source | ########################################### Replication role and policy ########################################### (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.replication_policy | data source | (inside ../../../modules/codepipeline) |
| data.aws_iam_policy_document.sns_topic_policy | data source | Allow CodeStar Notifications to publish into the topic |
| data.aws_kms_alias.s3kmskey | data source | (inside ../../../modules/codepipeline) |
| data.aws_kms_alias.s3kmskey_replica | data source | (inside ../../../modules/codepipeline) |
| data.aws_region.replica | data source | (inside ../../../modules/codepipeline) |
| data.aws_ssm_parameters_by_path.all_app_secrets | data source |  |
| data.terraform_remote_state.base | data source |  |
| data.terraform_remote_state.ecs_cluster | data source |  |
