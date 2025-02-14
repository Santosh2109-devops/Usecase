Data Ingestion:

Kinesis Firehose for streaming data ingestion
Data is automatically delivered to S3 raw data bucket
Automatic partitioning by year/month/day


Storage:

Raw data bucket for initial data storage
Processed data bucket for transformed data
Automatic data organization with prefixes


Processing:

Lambda function triggered by S3 events
Processes raw data and converts to required format
Stores results in processed data bucket (Another S3 Bucket)


Data Catalog & Analytics:

Glue Crawler to automatically catalog processed data
Glue Data Catalog for metadata management


Athena for SQL queries against processed data or Cloudwatch Insights
QuickSight for visualization or Grafana which is an opensource tool for visualization