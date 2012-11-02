class Evensong < ActiveRecord::Base
  include PgSearch

  belongs_to :composer
  belongs_to :genre

  has_many :links
  has_many :uploads

  before_destroy :remove_links
  before_destroy :remove_uploads

  delegate :name, :to => :genre, :prefix => true, :allow_nil => true
  delegate :name, :to => :composer, :prefix => true, :allow_nil => true

  validates_presence_of :title, :composer, :genre

  scope :ordered, :order => 'title ASC'
  scope :preloaded, :include => [:composer, :genre, :links, :uploads]

  pg_search_scope :searchahead,
                  :against => [:title, :soloists, :comment],
                  :using => { :tsearch => {:prefix => true} },
                  :associated_against => {:composer => :name,
                                          :genre => :name},
                  :ignoring => :accents

  pg_search_scope :search,
                  :against => [:title, :soloists, :comment],
                  :associated_against => {:composer => :name,
                                          :genre => :name},
                  :ignoring => :accents

  def typeahead(prefix)
    [title, soloists , comment, composer.try(:name), genre.try(:name)].map do |name|
      name and name.parameterize.split((/\W+/))
    end.flatten.select {|candidate| candidate and candidate.start_with? prefix.parameterize}.uniq
  end

  def self.excel
    NoteSheet.new([HeaderColumn.new(I18n.t('model.evensong.excel.sysid'), 8),
                   HeaderColumn.new(I18n.t('model.evensong.excel.title'), 50),
                   HeaderColumn.new(I18n.t('model.evensong.excel.psalm'), 8),
                   HeaderColumn.new(I18n.t('model.evensong.excel.soloists'), 35),
                   HeaderColumn.new(I18n.t('model.evensong.excel.composer'), 50),
                   HeaderColumn.new(I18n.t('model.evensong.excel.genre'), 35),
                   HeaderColumn.new(I18n.t('model.evensong.excel.comment'), 50)],
                  Evensong.ordered.preloaded,
                  I18n.t('model.evensong.excel.doctitle'),
                  lambda { |row, item|
                    row.push item.id
                    row.push item.title
                    row.push item.psalm
                    row.push item.soloists
                    row.push item.composer ? item.composer.name : ""
                    row.push item.genre ? item.genre.name : ""
                    row.push item.comment
                  })
  end

  private

  def remove_links
    self.links.each do |link|
      link.destroy
    end
  end

  def remove_uploads
    self.uploads.each do |upload|
      upload.destroy
    end
  end
end
