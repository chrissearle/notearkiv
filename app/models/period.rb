class Period < ActiveRecord::Base
  has_many :notes

  validates_presence_of :name

  scope :ordered, -> { order(:name) }
  scope :preloaded, -> { includes :notes }

  def deletable?
    notes.size == 0
  end
end
