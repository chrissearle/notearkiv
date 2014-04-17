class Note < ActiveRecord::Base
  belongs_to :genre, counter_cache: true
  belongs_to :language, counter_cache: true
  belongs_to :period, counter_cache: true
  belongs_to :composer, counter_cache: true
end
