class SearchController < ApplicationController
  filter_access_to :all

  before_action :set_search, only: [:search, :typeahead]

  def index
    type = params[:type]

    unless type == 'note' || type == 'evensong'
      type = %w(note evensong)
    end


    if params[:search].blank?
      query_part = {
          match_all: {}
      }
    else
      # We might want to move this to prefix search - see the commented search_all methods in note and evensong
      query_part = {
          multi_match: {
              fields: %w(title^10 comment soloists voice psalm item),
              query: params[:search]
          }
      }
    end

    filter = build_filter

    unless filter.blank?
      query_part = {
          filtered: {
              filter: filter,
              query: query_part
          }
      }
    end

    query = {
        query: query_part,
        size: 1000,
        aggregations: build_aggregations
    }

    @search = {}

    if type.include? 'note'
      @search[:notes] = Note.search(query)
    end

    if type.include? 'evensong'
      @search[:evensongs] = Evensong.search(query)
    end
  end

  def typeahead
    candidates = []
    candidates << @search[:notes].map { |n| n.typeahead(params[:search]) } unless @search[:notes].nil?
    candidates << @search[:evensongs].map { |n| n.typeahead(params[:search]) } unless @search[:evensongs].nil?

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

  def build_aggregations
    {
        composer: build_aggregation('composer'),
        genre: build_aggregation('genre'),
        period: build_aggregation('period'),
        language: build_aggregation('language')
    }
  end

  def build_filter
    terms = []

    terms << build_term(:composer)
    terms << build_term(:genre)
    terms << build_term(:period)
    terms << build_term(:language)

    terms.select! { |term| !term.nil? }

    unless terms.blank?
      if terms.size == 1
        terms[0]
      else
        {
            and: terms
        }
        end
    end
  end

  def build_aggregation(name)
    {
        nested: {
            path: name
        },
        aggregations: {
            counts: {
                terms: {
                    field: "#{name}.name.raw"
                }
            }
        }
    }
  end

  def build_term(term)
    params[term]

    unless params[term].blank?
      {
          nested: {
              path: term.to_s,
              filter: {
                  term: {
                      "#{term.to_s}.name.raw" => params[term]
                  }
              }
          }
      }
    end
  end

end
