# frozen_string_literal: true

CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    host: '192.168.2.192',
    endpoint: 'http://192.168.2.192:49154',
    path_style: true
  }
  config.fog_directory = ENV['S3_BUCKET_NAME']
end
