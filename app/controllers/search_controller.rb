class SearchController < ApplicationController
  layout "wide"
  
  filter_access_to :all

  def search
    search_param = params[:search]

    @search = Search.search(search_param)
  end

  def typeahead
    search = Search.search(params[:search])

    candidates = []
    candidates << search[:notes].map{|n| n.typeahead(params[:search])} unless search[:notes].nil?
    candidates << search[:evensongs].map{|n| n.typeahead(params[:search])} unless search[:evensongs].nil?

    render :json => candidates.flatten.uniq
  end
end