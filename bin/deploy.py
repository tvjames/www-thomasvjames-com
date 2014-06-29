#!/usr/bin/python
import argparse
import logging
import signal
import os

import boto
import boto.sqs
import time
import datetime
import json
import dateutil.parser
import tarfile

from boto.regioninfo import RegionInfo
from boto.sqs.message import RawMessage
from boto.s3.key import Key
import sys

# The following environment variables must be set if ~/.boto is not configured
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

def main(argv=None):
    def signal_handler(signal, frame):
        print 'CTRL+C Pressed, exiting'
        sys.exit(0)
    signal.signal(signal.SIGINT, signal_handler)

    parser = argparse.ArgumentParser(description='Process AWS resources and credentials.')
    parser.add_argument('--region', action='store', dest='region', required='true',
                        help='AWS Region in which the SQS and DynamoDB resources are located')
    parser.add_argument('--account', action='store', dest='account', required='true',
                        help='AWS Account Number in which the SQS queue is namespaced')
    parser.add_argument('--queue', action='store', dest='queue', required='true',
                        help='SQS queue containing deploy instructions')
    parser.add_argument('--bucket', action='store', dest='bucket', required='true',
                        help='S3 bucket containing deploy artefacts')
    parser.add_argument('--dest', action='store', dest='dest', default="public_html",
                        help='S3 bucket containing deploy artefacts')

    args = parser.parse_args()

    info_message('Retrieving instructions from queue %s. ' % (args.queue))
    info_message('Writing content to %s. ' % (args.dest))

    try:
        # Connect to SQS and open queue
        url = "https://sqs.%s.amazonaws.com/%s/%s" % (args.region, args.account, args.queue)
        sqs = boto.sqs.connect_to_region(args.region)
        queue = boto.sqs.queue.Queue(sqs, url=url)
        queue.set_message_class(RawMessage)

    except Exception as ex:
        error_message("Encountered an error connecting to SQS. Confirm that your queue names are correct")
        error_message(ex)
        sys.exit()

    info_message("Polling input queue...")

    while True:
        # Get messages
        rs = queue.get_messages(num_messages=1, visibility_timeout=10)

        if len(rs) > 0:
            # Iterate each message
            for raw_message in rs:
                process_raw_message(raw_message, queue, args.bucket, args.dest)
        else:
          break

    info_message("Exiting...")


def process_raw_message(raw_message, queue, bucket, dest):
    info_message("Message received...")
    info_message(raw_message.get_body())

    try:
        message = json.loads(raw_message.get_body())
        filename = message[u'Message']
        info_message("Processing %s." % filename)

        if not os.path.exists(filename):
          info_message("Downloading %s." % filename)
          s3 = boto.connect_s3()
          bucket = s3.get_bucket(bucket, validate=False)
          key = Key(bucket)
          key.key = filename
          key.get_contents_to_filename(filename)

        path = extract_artefacts(filename)
        copy_to_dest(path, dest)
        cleanup(path, filename, message[u'MessageId'])

        info_message("Message processed.")

        # Delete message from the queue
        queue.delete_message(raw_message)

    except Exception as ex:
        error_message("Unable to process message, exception occurred, message will be placed back on the queue")
        error_message(ex)


def extract_artefacts(filename):
    path = filename.replace(".tar.gz", "");
    info_message("Extracting %s to %s" % (filename, path))
    tar = tarfile.open(filename)
    tar.extractall(path=path)
    tar.close()
    return path


def copy_to_dest(source, destination):
    info_message("Copying from %s to %s" % (source, destination))
    os.system("mkdir -p %s" % (destination))
    os.system("cp -r %s/* %s" % (source, destination))

def cleanup(path, filename, id):
    info_message("Removing %s" % (path))
    os.system("rm -rf %s" % (path))

    os.system("mkdir -p deployed/%s" % (id))
    os.system("mv %s deployed/%s/%s" % (filename, id, filename))

def info_message(message):
    logger.info(message)


def error_message(message):
    logger.error(message)


class Logger:
    def __init__(self):
        FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        logging.basicConfig(format=FORMAT)
        self.file_handler = logging.FileHandler('queue_processor.log')
        self.file_handler.setFormatter(logging.Formatter(FORMAT))
        self.log = logging.getLogger('queue-processor')
        self.log.setLevel(logging.INFO)
        for handler in self.log.handlers:
            self.log.removeHandler(handler)
        self.log.addHandler(self.file_handler)

    def info(self, message):
        self.log.info(message)

    def error(self, message):
        self.log.error(message)


logger = Logger()

if __name__ == "__main__":
    sys.exit(main())
