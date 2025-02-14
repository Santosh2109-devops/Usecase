#Lambda function used inside the terraform folder

import json
import urllib.parse

def lambda_handler(event, context):
    # Handle both S3 event and scheduled event
    if 'Records' in event:  # This is an SNS event from S3
        for record in event['Records']:
            # Parse SNS message
            sns_message = json.loads(record['Sns']['Message'])
            
            # Extract S3 event details
            for s3_record in sns_message['Records']:
                bucket = s3_record['s3']['bucket']['name']
                key = urllib.parse.unquote_plus(s3_record['s3']['object']['key'])
                print(f"File uploaded: {key} in bucket: {bucket}")
    
    else:  # This is a scheduled event
        print("Triggered by schedule")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Processing completed successfully')
    }