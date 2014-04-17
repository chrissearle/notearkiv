class Evensong < ActiveRecord::Base
  belongs_to :genre, counter_cache: true
  belongs_to :composer, counter_cache: true
end
