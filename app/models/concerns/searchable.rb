module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name 'notearkiv'

    settings index: {} do
      mapping do
        indexes :title, analyzer: 'standard'
        indexes :soloists, analyzer: 'standard'
        indexes :comment, analyzer: 'standard'
        indexes :psalm, analyzer: 'keyword'
        indexes :id, analyzer: 'keyword'
        indexes :item, analyzer: 'keyword'
        indexes :voice, analyzer: 'keyword'

        indexes :genre, type: 'nested' do
          indexes :name, analyzer: 'standard'
        end

        indexes :composer, type: 'nested' do
          indexes :name, analyzer: 'standard'
        end

        indexes :period, type: 'nested' do
          indexes :name, analyzer: 'standard'
        end

        indexes :language, type: 'nested' do
          indexes :name, analyzer: 'standard'
        end
      end
    end

=begin
    mapping do
      # ...
    end

    def self.search(query)
      # ...
    end
=end
  end
end
