class SearchController < ApplicationController
  layout "wide"
  
  filter_access_to :all

  def search
    @notes = Note.search params[:search]
    @evensongs = Evensong.search params[:search]
  end
end