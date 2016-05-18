class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string 'file_name'
      t.string 'location'
      t.boolean 'public', default: true
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
