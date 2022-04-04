require_relative 'boot'

require 'rails/all'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hometown
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths += %W(#{config.root}/lib)
    config.time_zone = 'Mountain Time (US & Canada)'
    config.active_record.default_timezone = :local
    Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['SEARCHBOX_URL']
  end
end
