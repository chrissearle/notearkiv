class Evensong < ActiveRecord::Base
  belongs_to :composer
  belongs_to :genre

  has_many :links

  before_destroy :remove_links

  delegate :name, :to => :genre, :prefix => true, :allow_nil => true
  delegate :name, :to => :composer, :prefix => true, :allow_nil => true

  validates_presence_of :title, :composer, :genre

  scope :ordered, :order => 'title ASC'
  scope :preloaded, :include => [:composer, :genre, :links]

  private

  def remove_links
    self.links.each do |link|
      link.destroy
    end
  end
end
