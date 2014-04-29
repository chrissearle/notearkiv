module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings analysis: {
        analyzer: {
            lowerKeyword: {
                type: :custom,
                tokenizer: :keyword,
                filter: [:lowercase]
            }
        }
    } do
      mapping dynamic: 'false' do
        indexes :title, type: 'multi_field' do
          indexes :title, analyzer: 'standard'
          indexes :sort, analyzer: 'lowerKeyword'
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
          indexes :sort, analyzer: 'lowerKeyword'
        end

        indexes :instrument, type: 'multi_field' do
          indexes :instrument, analyzer: 'standard'
          indexes :raw, index: :not_analyzed
          indexes :sort, analyzer: 'lowerKeyword'
        end

        indexes :genre, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
            indexes :sort, analyzer: 'lowerKeyword'
          end
        end

        indexes :composer, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
            indexes :sort, analyzer: 'lowerKeyword'
          end
        end

        indexes :period, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
            indexes :sort, analyzer: 'lowerKeyword'
          end
        end

        indexes :language, type: 'nested' do
          indexes :name, type: 'multi_field' do
            indexes :name
            indexes :raw, index: :not_analyzed
            indexes :sort, analyzer: 'lowerKeyword'
          end
        end
      end
    end

    def self.full_reindex
      self.preloaded.import force: true
    end
  end
end
