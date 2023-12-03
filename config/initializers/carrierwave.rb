# frozen_string_literal: true

CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.asset_host = ENV['SERVER_URL']
  else
    break if ENV['BUCKET_ACCESS_KEY_ID'].blank? || ENV['BUCKET_SECRET_ACCESS_KEY'].blank? ||
             ENV['S3_BUCKET_NAME'].blank?
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['BUCKET_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['BUCKET_SECRET_ACCESS_KEY']
    }
    config.fog_directory  = ENV['S3_BUCKET_NAME']
  end
end
