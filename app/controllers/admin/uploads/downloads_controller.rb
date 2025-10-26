module Admin
  module Uploads
    class DownloadsController < ActionController::Base
      include AdminAuthentication

      def show
        @entry_file_upload = EntryFileUpload.find(params[:upload_id])
        send_data @entry_file_upload.content,
                  filename: "entry_file_#{@entry_file_upload.show.ffe_id}_#{@entry_file_upload.created_at.strftime('%Y%m%d_%H%M%S')}.xml",
                  type: "application/xml",
                  disposition: "attachment"
      end
    end
  end
end
