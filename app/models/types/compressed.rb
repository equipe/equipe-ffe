module Types
  class Compressed < ActiveRecord::Type::Text
    def serialize(value)
      return nil if value.nil?
      Base64.urlsafe_encode64(ActiveSupport::Gzip.compress(value))
    end

    def deserialize(value)
      return nil if value.nil?
      ActiveSupport::Gzip.decompress(Base64.urlsafe_decode64(value))
    end
  end
end
