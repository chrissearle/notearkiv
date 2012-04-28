# coding: UTF-8

module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def bootstrap_type(type)
    case type
      when :alert
        "warning"
      when :error
        "error"
      when :notice
        "info"
      when :success
        "success"
      else
        type.to_s
    end
  end

  def danger_button_class(object)
    if (object.deletable?)
      "btn btn-mini btn-danger"
    else
      "btn btn-mini btn-danger disabled"
    end
  end

  def search_link(value)
    unless value
      return ""
    end

    link_to value, search_path(:search => value)
  end
end
