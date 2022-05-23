CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'  
    config.storage = :fog                      # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],                        # required
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], 
      region: ENV['AWS_S3_REGION'],                      # required
    }
    config.fog_directory  = ENV['S3_BUCKET_NAME']                          # required
    # config.fog_public     = false                                        # optional, defaults to true
    # config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
  end
