module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings index: {number_of_shards: 1, number_of_replicas: 0} do
      mapping dynamic: 'false' do
        indexes :title, type: 'multi_field' do
          indexes :title, analyzer: 'standard'
          indexes :sort, index: :not_analyzed
        end

        indexes :soloists, analyzer: 'standard'
        indexes :comment, analyzer: 'standard'

        indexes :psalm, type: 'multi_field' do
          indexes :psalm, analyzer: 'keyword', type: 'string'
          indexes :sort, index: :not_analyzed, type: 'long'
        end

        indexes :id, analyzer: 'keyword'
        indexes :item, analyzer: 'keyword', type: 'string'

        indexes :voice, type: 'multi_field' do
          indexes :voice, analyzer: 'simple'
          indexes :raw, index: :not_analyzed
          indexes :sort, index: :not_analyzed

        end

        indexes :instrument, type: 'multi_field' do
          indexes :instrument, analyzer: 'standard'
          indexes :raw, index: :not_analyzed
          indexes :sort, index: :not_analyzed
        end

        indexes :genre, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
            indexes :sort, index: :not_analyzed
          end
        end

        indexes :composer, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
            indexes :sort, index: :not_analyzed
          end
        end

        indexes :period, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
            indexes :sort, index: :not_analyzed
          end
        end

        indexes :language, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
            indexes :sort, index: :not_analyzed
          end
        end
      end
    end

    def self.full_reindex
      self.preloaded.import force: true
    end
  end
end
