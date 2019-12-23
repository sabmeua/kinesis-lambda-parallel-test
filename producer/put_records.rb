require 'aws-sdk'
require 'dotenv'

Dotenv.load

kinesis = Aws::Kinesis::Client.new(region: ENV['AWS_DEFAULT_REGION'], profile: ENV['AWS_PROFILE'])

CNT = ARGV[0] || 300
STREAM_NAME = ENV['TEST_STREAM_NAME']
PKEY = 'client-001'

CNT.to_i.times do |i|
  kinesis.put_record(
    stream_name: STREAM_NAME,
    data: (i+1).to_s,
    partition_key: PKEY
  )
  sleep 1
end
