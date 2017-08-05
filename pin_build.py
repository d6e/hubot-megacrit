import os
import boto3

BUCKET_NAME = os.environ['BUCKET_NAME']


def lambda_handler(event, context):
    url = event['url']
    source_key = url.split(BUCKET_NAME)[1]
    source_key = source_key[1:] if source_key.startswith('/') else source_key
    s3 = boto3.client('s3')
    s3.copy({'Bucket': BUCKET_NAME, 'Key': source_key},
            BUCKET_NAME, source_key.replace('r/', 'pinned/'))
    return {
        'old_url': url,
        'new_url': url.replace('r/', 'pinned/')
    }
