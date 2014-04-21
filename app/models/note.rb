class Note < ActiveRecord::Base
  include PgSearch
  include AbstractNote

  belongs_to :genre, counter_cache: true
  belongs_to :language, counter_cache: true
  belongs_to :period, counter_cache: true
  belongs_to :composer, counter_cache: true

  before_destroy :remove_links
  before_destroy :remove_uploads

  has_many :links
  #has_many :uploads

  delegate :name, :to => :genre, :prefix => true, :allow_nil => true
  delegate :name, :to => :composer, :prefix => true, :allow_nil => true
  delegate :name, :to => :period, :prefix => true, :allow_nil => true
  delegate :name, :to => :language, :prefix => true, :allow_nil => true

  before_validation(:on => :create) { set_next_item }

  validates_presence_of :item, :title, :originals

  scope :ordered, -> { order(:title) }
  scope :preloaded, -> { includes :composer, :genre, :period, :language }
  #  scope :preloaded, -> { includes :composer, :genre, :period, :language, :links, :uploads }

  pg_search_scope :search,
                  :against => [:title, :voice, :soloists, :instrument, :comment],
                  :associated_against => {:composer => :name,
                                          :genre => :name,
                                          :period => :name,
                                          :language => :name},
                  :ignoring => :accents

  pg_search_scope :searchahead,
                  :against => [:title, :voice, :soloists, :instrument, :comment],
                  :using => { :tsearch => {:prefix => true} },
                  :associated_against => {:composer => :name,
                                          :genre => :name,
                                          :period => :name,
                                          :language => :name},
                  :ignoring => :accents

  def get_typeahead
    [title, voice, soloists, instrument, comment, composer_name, genre_name, period_name, language_name].flatten
  end

  def self.voices
    Note.select('distinct voice').map(&:voice).sort
  end

=begin
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
                    row.push item.language ? item.language.name : ""
                    row.push item.instrument
                    row.push item.originals
                    row.push item.copies
                    row.push item.instrumental
                    row.push item.voice
                    row.push item.soloists
                    row.push item.comment
                  })
  end
=end

  private

  def set_next_item
    self.item = Note.maximum(:item) + 1
  end
end
