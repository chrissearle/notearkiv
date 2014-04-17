class Note < ActiveRecord::Base
  belongs_to :genre, counter_cache: true
end
