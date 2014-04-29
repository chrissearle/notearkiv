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
      query_part = {
          bool: {
              should: [
                  {
                      multi_match: {
                          fields: %w(title^10 comment soloists voice psalm item instrument),
                          query: params[:search],
                          type: 'phrase_prefix'
                      }
                  },
                  {
                      nested: build_nested_match('composer')
                  },
                  {
                      nested: build_nested_match('genre')
                  },
                  {
                      nested: build_nested_match('language')
                  },
                  {
                      nested: build_nested_match('period')
                  }
              ]
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

    unless Rails.env.production?
      File.open('last-query.yml', 'w') do |file|
        file.write query.to_yaml
      end

      File.open('last-query.json', 'w') do |file|
        file.write query.to_json
      end
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
        #        instrument: build_aggregation('instrument', false)
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

  def build_aggregation(name, nested=true)
    field = "#{name}.raw"

    if nested
      field = "#{name}.name.raw"
    end

    aggregation = {
        counts: {
            terms: {
                field: field
            }
        }
    }

    if nested
      aggregation = {
          nested: {
              path: name
          },
          aggregations: aggregation
      }
    end

    aggregation
  end

  def build_nested_match(field)
    key = "#{field}.name"

    {
        path: field,
        query: {
            match: {
                key => {
                    query: params[:search],
                    type: 'phrase_prefix'
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
