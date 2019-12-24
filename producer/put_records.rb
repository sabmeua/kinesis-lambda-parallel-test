require 'aws-sdk'
require 'dotenv'

Dotenv.load

kinesis = Aws::Kinesis::Client.new(region: ENV['AWS_DEFAULT_REGION'], profile: ENV['AWS_PROFILE'])

DATA_CNT = (ARGV[0] || 60).to_i
STREAM_NAME = ENV['TEST_STREAM_NAME']
CLIENT_NUM = 5

1.step(DATA_CNT) do |i|
  1.step(CLIENT_NUM) do |j|
    kinesis.put_record(
      stream_name: STREAM_NAME,
      data: i.to_s,
      partition_key: j.to_s
    )
  end
  sleep 1
end
