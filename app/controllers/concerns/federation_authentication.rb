module FederationAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_federation
  end

  private

  def authenticate_federation
    head :unauthorized unless valid_federation_api_key?
  end

  def valid_federation_api_key?
    expected = Rails.application.credentials.federation_api_key.to_s
    given = request.headers["X-Federation-Api-Key"].to_s
    expected.present? && ActiveSupport::SecurityUtils.secure_compare(given, expected)
  end
end
