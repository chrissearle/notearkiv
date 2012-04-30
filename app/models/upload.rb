class Upload < ActiveRecord::Base
  belongs_to :note
  belongs_to :evensong

  validates_presence_of :path

  before_destroy :remove_file

  def display_name
    self.title || self.path
  end

  def media
    @media ||= DropboxWrapper.get_media(self.path)
  end

  private

  def remove_file
    # TODO Remove from dropbox
  end
end
