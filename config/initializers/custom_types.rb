Rails.application.config.to_prepare do
  ActiveRecord::Type.register(:compressed, Types::Compressed)
end
