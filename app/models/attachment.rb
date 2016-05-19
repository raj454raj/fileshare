class Attachment < ActiveRecord::Base
  belongs_to :user
  has_attached_file :doc
end
