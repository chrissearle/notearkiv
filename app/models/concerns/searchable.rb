module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings index: {number_of_shards: 1, number_of_replicas: 0} do
      mapping dynamic: 'false' do
        indexes :title, analyzer: 'standard'
        indexes :soloists, analyzer: 'standard'
        indexes :comment, analyzer: 'standard'
        indexes :psalm, analyzer: 'keyword', type: 'string'
        indexes :id, analyzer: 'keyword'
        indexes :item, analyzer: 'keyword', type: 'string'
        indexes :voice, analyzer: 'keyword'

        indexes :instrument, type: 'multi_field' do
          indexes :instrument, analyzer: 'standard'
          indexes :raw, index: :not_analyzed
        end

        indexes :genre, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
          end
        end

        indexes :composer, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
          end
        end

        indexes :period, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
          end
        end

        indexes :language, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
          end
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
