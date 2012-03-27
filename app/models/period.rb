class Period < ActiveRecord::Base
#  has_many :notes

  validates_presence_of :name

  scope :ordered, :order => 'name ASC'
#  scope :preloaded, :include => [:notes]

  def deletable?
#    notes.size() == 0
    true
  end

end
