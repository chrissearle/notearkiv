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

  def get_icon_for_path(path)
    ext = path.gsub(/.*\./, '')

    case ext
      when "pdf" then
        "icon-book"
      when "zip" then
        "icon-download-alt"
      when "mp3" then
        "icon-music"
      when "m4a" then
        "icon-music"
      else
        "icon-file"
    end
  end

  def media_link(upload)
    unless upload.media
      return "#{upload.display_name} - #{t('media.file.missing')}"
    end

    link_to "<i class='#{get_icon_for_path(upload.path)}'></i>".html_safe + upload.display_name, upload.media
  end

  def link_with_icon(icon, text, white=false)
    "<i class='#{white ? "#{icon} icon-white" : icon}'></i> #{text}".html_safe
  end

  def safe_size(items)
    items.size if items.size > 0
  end

  def upload_back_item(path)
    Upload.search_path(path)
  end

  def upload_back_link(path)
    upload = upload_back_item(path)

    if upload
      if upload.note
        link_to "#{t('model.note.title')}: #{upload.note.title}", note_path(upload.note)
      else
        link_to "#{t('model.evensong.title')}: #{upload.evensong.title}", evensong_path(upload.evensong)
      end
    end
  end
end
