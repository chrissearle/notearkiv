class Note < ActiveRecord::Base
  before_destroy :remove_links

  belongs_to :composer
  belongs_to :genre
  belongs_to :period

  has_many :note_language_assignments
  has_many :languages, :through => :note_language_assignments

  has_many :links

  delegate :name, :to => :genre, :prefix => true, :allow_nil => true
  delegate :name, :to => :composer, :prefix => true, :allow_nil => true
  delegate :name, :to => :period, :prefix => true, :allow_nil => true

  before_validation(:on => :create) { set_next_item }

  validates_presence_of :item, :title, :count_originals

  scope :ordered, :order => 'title ASC'
  scope :preloaded, :include => [:composer, :genre, :period, :languages, :links]

  def self.voices
    Note.select('distinct voice').map(&:voice).sort
  end

  private

  def set_next_item
    self.item = Note.maximum(:item) + 1
  end

  def remove_links
    self.links.each do |link|
      link.destroy
    end
  end

end
