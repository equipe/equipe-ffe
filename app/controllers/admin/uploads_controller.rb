module Admin
  class UploadsController < ActionController::Base
    include AdminAuthentication

    def index
      @entry_file_uploads = EntryFileUpload
        .select(EntryFileUpload.column_names.excluding("content"))
        .includes(:show)
        .order(created_at: :desc)
        .limit(500)
    end
  end
end
