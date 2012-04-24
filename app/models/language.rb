class Language < ActiveRecord::Base
#  has_many :note_language_assignments
#  has_many :notes, :through => :note_language_assignments

  validates_presence_of :name

  scope :ordered, :order => 'name ASC'
#  scope :preloaded, :include => [:notes]

  def deletable?
#    notes.size() == 0

    true
  end

end
