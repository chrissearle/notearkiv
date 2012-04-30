class Upload < ActiveRecord::Base
  belongs_to :note
  belongs_to :evensong

  validates_presence_of :path

  before_destroy :remove_file

  before_create :make_path
  after_create :send

  def display_name
    self.title || self.path
  end

  def media
    @media ||= DropboxWrapper.get_media(self.path)
  end

  private

  def make_path
    filename = [self.id, (self.note ? self.note.id : self.evensong.id)].join('_')
    ext = '???' #TODO get ext

    self.path = "#{filename}.#{ext}"
  end

  def send
    #TODO send
  end

  def remove_file
    DropboxWrapper.remove(self.path)
  end
end
