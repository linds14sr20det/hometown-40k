PayPal::SDK.load("config/paypal.yml", Rails.env)
PayPal::SDK.logger = Rails.logger


PayPal::SDK::Core::Util::HTTPHelper.class_eval do
  def default_ca_file
    File.expand_path("../../data/paypal.crt", __dir__)
  end
end
