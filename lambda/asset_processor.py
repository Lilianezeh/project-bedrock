import json
import logging
import urllib.parse

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """
    Triggered by S3 PutObject events.
    Logs the filename of every uploaded file to CloudWatch.
    """
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key    = urllib.parse.unquote_plus(
                   record['s3']['object']['key'],
                   encoding='utf-8'
                 )
        logger.info(f"Image received: {key}")
        print(f"Image received: {key}")

    return {
        'statusCode': 200,
        'body': json.dumps('Processed successfully')
    }