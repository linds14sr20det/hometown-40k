class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :calculate_s3, only: [:edit, :new]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  private

  def calculate_s3
    options = {
        # The name of your bucket.
        bucket: ENV['S3_BUCKET'],

        # S3 region. If you are using the default us-east-1, it this can be ignored.
        region: 'us-west-2',

        # The folder where to upload the images.
        keyStart: 'uploads',

        # File access.
        acl: 'public-read',

        # AWS keys.
        accessKey: ENV['AWS_ACCESS_KEY_ID'],
        secretKey: ENV['AWS_SECRET_ACCESS_KEY']
    }

    # Compute the signature.
    @aws_data = FroalaEditorSDK::S3.data_hash(options)
  end
end
