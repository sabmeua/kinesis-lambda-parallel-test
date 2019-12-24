require 'json'
require 'base64'
require 'aws-sdk'

def main(event:, context:)
  dynamoDB = Aws::DynamoDB::Resource.new(region: ENV['AWS_DEFAULT_REGION'])
  table = dynamoDB.table(ENV['DYNAMODB_TABLE'])
  items = {
    'aws_request_id' => context.aws_request_id,
    'records' => [],
    'start' => Time.now.to_s
  }
  event['Records'].each do |rec|
    client_no = rec['kinesis']['partitionKey']
    data_no = Base64.decode64(rec['kinesis']['data']).to_i
    items['records'] << "#{client_no}-#{data_no}"
    sleep 3
  end
  items['end'] = Time.now.to_s
  table.put_item({item: items})
  { statusCode: 200 }
end
