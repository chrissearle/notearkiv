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
      prefix = []

      if self.note
        prefix << self.note.title.parameterize
        prefix << note.id
      end

      if self.evensong
        prefix << self.evensong.title.parameterize
        prefix << evensong.id
      end

      self.path = "/#{prefix.join('_')}_#{@uploadfile.original_filename.downcase.gsub(/ /, "_")}"

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
