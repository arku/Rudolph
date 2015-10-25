DisqusRails.setup do |config|
  config::SHORT_NAME = ENV['disqus_short_name']
  config::SECRET_KEY = ENV['disqus_secret_key']
  config::PUBLIC_KEY = ENV['disqus_public_key']
  config::ACCESS_TOKEN = ENV['disqus_access_token']
end