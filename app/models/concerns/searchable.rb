module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

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
