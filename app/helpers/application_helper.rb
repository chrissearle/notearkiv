module ApplicationHelper
  def link_with_icon(icon, text, white=false)
    "<span class='glyphicon glyphicon-#{icon} #{'white' if white}'></span> #{text}".html_safe
  end

  def search_link(value)
    if value.blank?
      return ''
    end

    link_to link_with_icon('search', value), search_path(:search => value.to_s.gsub(/[^0-9A-Za-z ]/, '').split.first)
  end


  def title(page_title, show_title = true)
    title = strip_tags(page_title.to_s)

    if show_title
      content_for(:heading) { title }
    end

    content_for(:title) { "#{title} - OCHS" }
  end

  def msgtype_line(type)
    case type
      when 'info'
        title = 'INFO'
        icon = 'info-sign'
      when 'warning'
        title = 'WARNING'
        icon = 'warning-sign'
      else
        title = 'ERROR'
        icon = 'exclamation-sign'
    end

    "<a data-toggle='tooltip' data-placement='top' title='#{title}'><span class='glyphicon glyphicon-#{icon}'></span></a>".html_safe
  end

  def active_line(flag)
    case flag
      when true
        title = 'ACTIVE'
        icon = 'ok'
      else
        title = 'INACTIVE'
        icon = 'off'
    end

    "<a data-toggle='tooltip' data-placement='top' title='#{title}'><span class='glyphicon glyphicon-#{icon}'></span></a>".html_safe
  end

  def markdown(text)
    Kramdown::Document.new(text).to_html.html_safe
  end

  def bootstrap_type(type)
    case type
      when :alert
        'warning'
      when :error
        'danger'
      when :notice
        'info'
      when :success
        'success'
      else
        type.to_s
    end
  end
end
