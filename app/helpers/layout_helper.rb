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
    if object.deletable?
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

  def media_link(upload)
    unless upload.media
      return upload.display_name
    end

    css_class = "icon-file"

    if upload.path.ends_with? "pdf"
      css_class = "icon-book"
    end
    if upload.path.ends_with? "zip"
      css_class = "icon-download-alt"
    end
    if upload.path.ends_with? "mp3"
      css_class = "icon-music"
    end
    if upload.path.ends_with? "m4a"
      css_class = "icon-music"
    end

    link_to "<i class='#{css_class}'></i>".html_safe + upload.display_name, upload.media
  end
end
