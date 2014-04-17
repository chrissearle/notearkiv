class Evensong < ActiveRecord::Base
  belongs_to :genre, counter_cache: true
end
