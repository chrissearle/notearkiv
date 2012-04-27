class Note < ActiveRecord::Base
  include PgSearch

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

  pg_search_scope :search,
                  :against => [:title, :voice, :soloists],
                  :associated_against => {:composer => :name,
                                          :genre => :name,
                                          :period => :name,
                                          :languages => :name},
                  ignoring: :accents

  def self.voices
    Note.select('distinct voice').map(&:voice).sort
  end

  def self.excel
    NoteSheet.new([HeaderColumn.new(I18n.t('model.note.excel.sysid'), 8),
                   HeaderColumn.new(I18n.t('model.note.excel.id'), 8),
                   HeaderColumn.new(I18n.t('model.note.excel.title'), 50),
                   HeaderColumn.new(I18n.t('model.note.excel.composer'), 35),
                   HeaderColumn.new(I18n.t('model.note.excel.genre'), 35),
                   HeaderColumn.new(I18n.t('model.note.excel.epoch'), 35),
                   HeaderColumn.new(I18n.t('model.note.excel.language'), 35),
                   HeaderColumn.new(I18n.t('model.note.excel.instrument'), 35),
                   HeaderColumn.new(I18n.t('model.note.excel.originals'), 8),
                   HeaderColumn.new(I18n.t('model.note.excel.copies'), 8),
                   HeaderColumn.new(I18n.t('model.note.excel.instrumental'), 8),
                   HeaderColumn.new(I18n.t('model.note.excel.voices'), 15),
                   HeaderColumn.new(I18n.t('model.note.excel.soloists'), 35),
                   HeaderColumn.new(I18n.t('model.note.excel.comment'), 50)],
                  Note.ordered.preloaded,
                  I18n.t('model.note.excel.doctitle'),
                  lambda { |row, item|
                    row.push item.id
                    row.push item.item
                    row.push item.title
                    row.push item.composer ? item.composer.name : ""
                    row.push item.genre ? item.genre.name : ""
                    row.push item.period ? item.period.name : ""
                    row.push item.languages.map { |lang| lang.name }.join(", ")
                    row.push item.instrument
                    row.push item.originals
                    row.push item.copies
                    row.push item.instrumental
                    row.push item.voice
                    row.push item.soloists
                    row.push item.comment
                  })
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
