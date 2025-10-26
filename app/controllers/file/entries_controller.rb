class File::EntriesController < ApplicationController
  wrap_parameters false

  def create
    entry_file = EntryFile.new(file_content)
    if entry_file.valid?
      entry_file.import
      EntryFileUpload.create(
        content: file_content,
        show: entry_file.show,
        federation_organizer_id: request.headers["HTTP_X_FEDERATION_ORGANIZER_ID"],
        federation_user_name: request.headers["HTTP_X_FEDERATION_USER_NAME"],
        federation_user_email: request.headers["HTTP_X_FEDERATION_USER_EMAIL"]
      )
      entries = Equipe::Entries.new(entry_file.show)
      render json: entries.as_json
    else
      head :unprocessable_entity
    end
  end

  private

    def file_content
      @file_content ||= request.body.read
    end
end
