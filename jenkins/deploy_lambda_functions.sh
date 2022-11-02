#!/usr/bin/env bash
set -eo pipefail
source ${WORKSPACE}/jenkins/logging.sh

deploy_lambda_functions() {
  for function_name in $(echo "${LAMBDA_FUNCTION_NAMES}" | tr ',' ' '); do
    case "${function_name}" in
      "visitor-ids-stream-consumer")
        S3_KEY="java-platform/visitors_stream_processor_lambda/${SOURCE_VERSION}_visitors_stream_processor_lambda.jar"
        ;;
      "da-purge")
        S3_KEY="java-platform/data_access_worker_lambda/${SOURCE_VERSION}_data_access_worker_lambda.jar"
        ;;
      "visitor-api-delete" | "visitor-api-get")
        S3_KEY="java-platform/visitor_api/${SOURCE_VERSION}_visitor_api.jar"
        ;;
      "audience-sizing-jobs-launcher")
        S3_KEY="java-platform/audience_sizing_jobs_launcher_lambda/${SOURCE_VERSION}_audience_sizing_jobs_launcher_lambda.jar"
        ;;
      "metrics-aggregator")
        S3_KEY="java-platform/metrics_aggregator_lambda/${SOURCE_VERSION}_metrics_aggregator_lambda.jar"
        ;;
      *)
        msg_and_exit 1 "Can't recognize lambda function: ${function_name}"
        ;;
    esac

    echo -e "aws lambda update-function-code \
      --function-name ${ENVIRONMENT_PREFIX}${ENVIRONMENT}-${function_name} \
      --s3-bucket artifacts-${REGION}-teal --s3-key ${S3_KEY}" \
      | ( TAB=$'\t' ; sed "s/^/$TAB/" )
  done
}

test -n "${REGION}" || msg_and_exit 1 "deploy_lambda_functions.sh: REGION environment variable must be populated."
deploy_lambda_functions
