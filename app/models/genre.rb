class Genre < ActiveRecord::Base
  has_many :notes
  has_many :evensongs

  validates_presence_of :name

  scope :ordered, -> { order(:name) }
  scope :preloaded, -> { includes :notes, :evensongs }

  def deletable?
    notes.size == 0 && evensongs.size == 0
  end
end
