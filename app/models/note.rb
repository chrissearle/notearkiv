class Note < ActiveRecord::Base
  include AbstractNote
  include Searchable

  belongs_to :genre, counter_cache: true
  belongs_to :language, counter_cache: true
  belongs_to :period, counter_cache: true
  belongs_to :composer, counter_cache: true

  before_destroy :remove_links
  before_destroy :remove_uploads

  index_name 'notearkiv'

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

  def get_typeahead
    [title, voice, soloists, instrument, comment, composer_name, genre_name, period_name, language_name].flatten
  end

  def self.voices
    Note.select('distinct voice').map(&:voice).sort
  end

  def as_indexed_json(options={})
    as_json(methods: [:genre_name, :language_name, :period_name, :composer_name], only: [:comment, :item, :soloists, :title, :voice, :id])
  end

  begin
    def self.excel
      NoteSheet.new([HeaderColumn.new(I18n.t('table.title.sysid'), 8),
                     HeaderColumn.new(I18n.t('table.title.item'), 8),
                     HeaderColumn.new(I18n.t('table.title.title'), 50),
                     HeaderColumn.new(I18n.t('table.title.composer'), 35),
                     HeaderColumn.new(I18n.t('table.title.genre'), 35),
                     HeaderColumn.new(I18n.t('table.title.period'), 35),
                     HeaderColumn.new(I18n.t('table.title.language'), 35),
                     HeaderColumn.new(I18n.t('table.title.instrument'), 35),
                     HeaderColumn.new(I18n.t('table.title.originals'), 8),
                     HeaderColumn.new(I18n.t('table.title.copies'), 8),
                     HeaderColumn.new(I18n.t('table.title.instrumental'), 8),
                     HeaderColumn.new(I18n.t('table.title.voices'), 15),
                     HeaderColumn.new(I18n.t('table.title.soloists'), 35),
                     HeaderColumn.new(I18n.t('table.title.comment'), 50)],
                    Note.ordered.preloaded,
                    I18n.t('page.notes.title'),
                    lambda { |row, item|
                      row.push item.id
                      row.push item.item
                      row.push item.title
                      row.push item.composer_name
                      row.push item.genre_name
                      row.push item.period_name
                      row.push item.language_name
                      row.push item.instrument
                      row.push item.originals
                      row.push item.copies
                      row.push item.instrumental
                      row.push item.voice
                      row.push item.soloists
                      row.push item.comment
                    })
    end
  end

  def self.search_all(terms)

    queries = []

    terms.strip.split(/\s+/).each do |term|
      queries << {'prefix' => {'title' => term}}
      queries << {'prefix' => {'comment' => term}}
      queries << {'prefix' => {'voice' => term}}
      queries << {'prefix' => {'soloists' => term}}
      queries << {'prefix' => {'period_name' => term}}
      queries << {'prefix' => {'language_name' => term}}
      queries << {'prefix' => {'genre_name' => term}}
      queries << {'prefix' => {'composer_name' => term}}
    end

    self.search query: {
        'dis_max' => {
            'tie_breaker' => 0.7,
            'boost' => 1.2,
            'queries' => queries
        }
    }
  end

  private

  def set_next_item
    self.item = Note.maximum(:item) + 1
  end
end
