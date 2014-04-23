class Evensong < ActiveRecord::Base
  include PgSearch
  include AbstractNote
  include Searchable

  belongs_to :genre, counter_cache: true
  belongs_to :composer, counter_cache: true

  index_name 'notearkiv'

  has_many :links
#  has_many :uploads

  before_destroy :remove_links
  before_destroy :remove_uploads

  delegate :name, :to => :genre, :prefix => true, :allow_nil => true
  delegate :name, :to => :composer, :prefix => true, :allow_nil => true

  validates_presence_of :title, :composer, :genre

  scope :ordered, -> { order(:title) }
  scope :preloaded, -> { includes :composer, :genre }
#  scope :preloaded, -> { includes :composer, :genre, :links, :uploads }

  pg_search_scope :searchahead,
                  :against => [:title, :soloists, :comment],
                  :using => {:tsearch => {:prefix => true}},
                  :associated_against => {:composer => :name,
                                          :genre => :name},
                  :ignoring => :accents

  pg_search_scope :search,
                  :against => [:title, :soloists, :comment],
                  :associated_against => {:composer => :name,
                                          :genre => :name},
                  :ignoring => :accents

  def get_typeahead
    [title, soloists, comment, composer_name, genre_name]
  end

  def as_indexed_json(options={})
    as_json(methods: [:genre_name, :composer_name], only: [:title, :psalm, :soloists, :comment, :id])
  end

  begin
    def self.excel
      NoteSheet.new([HeaderColumn.new(I18n.t('table.title.sysid'), 8),
                     HeaderColumn.new(I18n.t('table.title.title'), 50),
                     HeaderColumn.new(I18n.t('table.title.psalm'), 8),
                     HeaderColumn.new(I18n.t('table.title.soloists'), 35),
                     HeaderColumn.new(I18n.t('table.title.composer'), 50),
                     HeaderColumn.new(I18n.t('table.title.genre'), 35),
                     HeaderColumn.new(I18n.t('table.title.comment'), 50)],
                    Evensong.ordered.preloaded,
                    I18n.t('page.evensongs.title'),
                    lambda { |row, item|
                      row.push item.id
                      row.push item.title
                      row.push item.psalm
                      row.push item.soloists
                      row.push item.composer_name
                      row.push item.genre_name
                      row.push item.comment
                    })
    end
  end
end
