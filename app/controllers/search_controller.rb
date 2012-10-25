class SearchController < ApplicationController
  layout "wide"
  
  filter_access_to :all

  def search
    @notes = Note.search params[:search]
    @evensongs = Evensong.search params[:search]
  end

  def typeahead
    @notes = Note.searchahead params[:search]
    @evensongs = Evensong.searchahead params[:search]

    candidates = []
    candidates << @notes.map{|n| n.typeahead(params[:search])} unless @notes.nil?
    candidates << @evensongs.map{|n| n.typeahead(params[:search])} unless @evensongs.nil?

    render :json => candidates.flatten.uniq
  end
end