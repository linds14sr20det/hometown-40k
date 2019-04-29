if File.exists?("config/elasticsearch.yml")
  config = YAML.load_file("config/elasticsearch.yml")[Rails.env].symbolize_keys
  config[:host] = ENV['SEARCHBOX_URL']
  Elasticsearch::Model.client = Elasticsearch::Client.new(config)
end
