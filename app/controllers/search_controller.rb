class SearchController < ApplicationController
  filter_access_to :all

  before_action :set_search, only: [:search, :typeahead]

  def search
    session[:lastsearch] = params[:search]
  end

  def typeahead
    candidates = []
    candidates << @search[:notes].map{|n| n.typeahead(params[:search])} unless @search[:notes].nil?
    candidates << @search[:evensongs].map{|n| n.typeahead(params[:search])} unless @search[:evensongs].nil?

    render :json => candidates.flatten.uniq
  end

  private

  def set_search
    search_param = params[:search]
    @search = {
        :notes => Note.search_all(search_param.downcase).records.to_a,
        :evensongs => Evensong.search_all(search_param.downcase).records.to_a
    }
  end

end


