import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('VisitorCounter')

def lambda_handler(event, context):
    # Retrieve the current count from DynamoDB
    response = table.get_item(Key={'id': 'visitor_count'})
    
    # Default count if the item doesn't exist
    count = response.get('Item', {}).get('count', 0)
    
    # Increment the count
    count += 1
    
    # Update the count in DynamoDB
    table.put_item(Item={'id': 'visitor_count', 'count': count})
    
    # Return the updated count as a response
    return {
        'statusCode': 200,
        'body': json.dumps({'count': count})
    }
