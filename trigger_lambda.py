#As per the requirement 
#Python function to trigger the lambda from local

import boto3
import json
import argparse

def trigger_lambda(function_name, region='us-east-1', payload=None):
    try:
        lambda_client = boto3.client('lambda', region_name=region)
        
        if payload is None:
            payload = {
                "test": "Triggered from local machine",
                "source": "manual_trigger"
            }
        
        response = lambda_client.invoke(
            FunctionName=function_name,
            InvocationType='RequestResponse',
            Payload=json.dumps(payload)
        )
        
        response_payload = json.loads(response['Payload'].read().decode('utf-8'))
        
        print("Lambda function triggered successfully!")
        print("Status code:", response['StatusCode'])
        print("Response payload:", json.dumps(response_payload, indent=2))
        
        # Check for function errors
        if 'FunctionError' in response:
            print("Error in function execution:")
            print(response['FunctionError'])
            
    except Exception as e:
        print(f"Error triggering Lambda function: {str(e)}")

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description='Trigger AWS Lambda function')
    parser.add_argument('--function-name', required=True, help='Name of the Lambda function')
    parser.add_argument('--region', default='us-east-1', help='AWS region (default: us-east-1)')
    parser.add_argument('--payload', help='JSON payload string (optional)')
    
    args = parser.parse_args()
    
    # Parse payload if provided
    payload = None
    if args.payload:
        try:
            payload = json.loads(args.payload)
        except json.JSONDecodeError:
            print("Error: Invalid JSON payload")
            return
    
    # Trigger the function
    trigger_lambda(args.function_name, args.region, payload)

if __name__ == "__main__":
    main()