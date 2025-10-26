module AdminAuthentication
  extend ActiveSupport::Concern

  included do
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    before_action :authenticate_admin
  end

  private

  def authenticate_admin
    authenticate_or_request_with_http_basic do |username, password|
      expected_password = Rails.application.credentials.dig(:admin, :password)
      ActiveSupport::SecurityUtils.secure_compare(username, "admin") &
        ActiveSupport::SecurityUtils.secure_compare(password, expected_password)
    end
  end
end
