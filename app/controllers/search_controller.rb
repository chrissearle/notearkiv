class SearchController < ApplicationController
  filter_access_to :all

  def search
    search_param = params[:search]

    session[:lastsearch] = search_param

    @search = {
        :notes     => Note.search_all(search_param.downcase).records.to_a,
        :evensongs => Evensong.search_all(search_param.downcase).records.to_a
    }
  end

  def typeahead
    search = Search.search(params[:search])

    candidates = []
    candidates << search[:notes].map{|n| n.typeahead(params[:search])} unless search[:notes].nil?
    candidates << search[:evensongs].map{|n| n.typeahead(params[:search])} unless search[:evensongs].nil?

    render :json => candidates.flatten.uniq
  end

end


