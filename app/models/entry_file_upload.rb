class EntryFileUpload < ApplicationRecord
  belongs_to :show

  attribute :content, :compressed

  validates :content, presence: true
  validates :content_hash, uniqueness: { scope: :show_id }

  before_validation :set_content_attributes

  delegate :organizer, to: :show

  private

  def set_content_attributes
    return unless content.present?

    self.content_size = content.bytesize
    self.content_hash = Digest::SHA256.hexdigest(content)
  end
end
