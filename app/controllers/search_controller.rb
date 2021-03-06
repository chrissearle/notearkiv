class SearchController < ApplicationController
  filter_access_to :all

  def index
    type = params[:type]

    unless type == 'note' || type == 'evensong'
      type = %w(note evensong)
    end

    set_search(type)
  end

  def typeahead
    set_search(%w(note evensong))

    candidates = []
    candidates << Note.preloaded.where(id: @search[:notes].records.ids).map { |n| n.typeahead(params[:search]) } unless @search[:notes].nil?
    candidates << Evensong.preloaded.where(id: @search[:evensongs].records.ids).map { |n| n.typeahead(params[:search]) } unless @search[:evensongs].nil?

    render :json => candidates.flatten.uniq
  end

  private


  def set_search(type)
    query = build_query

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


  def build_query
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
                          fields: %w(title^10 comment soloists psalm item instrument voice),
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

    if params[:sort]
      query['sort'] = build_sort
    end

    query
  end

  def build_aggregations
    {
        composer: build_aggregation('composer'),
        genre: build_aggregation('genre'),
        period: build_aggregation('period'),
        language: build_aggregation('language'),
        voice: build_aggregation('voice', false),
        instrument: build_aggregation('instrument', false)
    }
  end

  def build_filter
    terms = []

    terms << build_term(:composer)
    terms << build_term(:genre)
    terms << build_term(:period)
    terms << build_term(:language)
    terms << build_term(:voice, false)
    terms << build_term(:instrument, false)

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
        terms: {
            field: field
        }
    }

    if nested
      aggregation = {
          nested: {
              path: name
          },
          aggregations: {
              counts: aggregation
          }
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

  def build_term(term, nested=true)
    unless params[term].blank?
      field = "#{term.to_s}.raw"

      if nested
        field = "#{term.to_s}.name.raw"
      end

      filter = {
          term: {
              field => params[term]
          }
      }

      if nested
        filter = {
            nested: {
                path: term.to_s,
                filter: filter
            }
        }
      end

      filter
    end
  end

  def build_sort
    direction = 'asc'

    unless params[:direction].blank?
      if params[:direction].downcase == 'desc'
        direction = 'desc'
      end
    end

    key = "#{params[:sort]}.sort"
    sort = {}
    sort[key] = {}
    sort[key]['order'] = direction

    if params[:sort].include? '.'
      sort[key]['nested_path'] = params[:sort].gsub(/\..*/, '')
    end

    [] << sort
  end

end
