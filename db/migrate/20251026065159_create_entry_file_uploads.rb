class CreateEntryFileUploads < ActiveRecord::Migration[8.1]
  def change
    create_table :entry_file_uploads do |t|
      t.text :content
      t.integer :content_size
      t.string :content_hash
      t.string :federation_organizer_id
      t.string :federation_user_name
      t.string :federation_user_email
      t.references :show, null: false, foreign_key: true

      t.timestamps
    end

    add_index :entry_file_uploads, [:show_id, :content_hash], unique: true
  end
end
