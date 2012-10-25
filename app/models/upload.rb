class Upload < ActiveRecord::Base
  belongs_to :note
  belongs_to :evensong

  validates_presence_of :path

  before_destroy :remove_file

  before_validation :make_path

  after_create :send_file

  attr_accessor :uploadfile

  def display_name
    self.title || self.path
  end

  def media
    begin
      @media ||= DropboxWrapper.get_media(self.path)
    rescue DropboxError => de
      Rails.logger.warn "Dropbox error #{de.error}"
      @media = nil
    end
  end

  def self.search_path(path)
    self.find_by_path(path)
  end

  private

  def make_path
    @send_file = false

    if path.nil?
      self.path = "/#{@uploadfile.original_filename}"

      @send_file = true
    end
  end

  def send_file
    if @send_file
      DropboxWrapper.upload(@uploadfile.tempfile, self.path)
    end
  end

  def remove_file
    DropboxWrapper.remove(self.path)
  end
end
