# coding: UTF-8

module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { strip_tags("#{page_title.to_s} - OCHS") }
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
    ext = path.gsub(/.*\./, '').downcase.to_sym

    ext = :default unless DROPBOX_FILE_ICONS.has_key? ext

    DROPBOX_FILE_ICONS[ext]
  end

  def media_link(upload, refresh_cache=false)
    unless refresh_cache
      unless upload.media
        return "#{upload.display_name} - #{t('media.file.missing')}"
      end
    end

    link_to "<i class='#{get_icon_for_path(upload.path)}'></i>".html_safe + upload.display_name, upload.media(refresh_cache)
  end

  def short_media_link(upload, source)
    media = upload.media

    if media.nil?
      link_to "<i class='#{get_icon_for_path(upload.path)}'></i>".html_safe, source, :rel => 'popover', :data => {:trigger => 'hover', :title => upload.display_name, :content => t('upload.not.available')}
    else
      link_to "<i class='#{get_icon_for_path(upload.path)}'></i>".html_safe, upload.media, :rel => 'tooltip', :title => upload.display_name
    end
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

  def link_title(link)
    title = ""
    unless link.note.nil?
      title = "#{t('model.note.title')}: <em>#{link.note.title}</em>".html_safe
    end
    unless link.evensong.nil?
      title = "#{t('model.evensong.title')}: <em>#{link.evensong.title}</em>".html_safe
    end
    title
  end

  def upload_title(prefix, upload)
    title = ""
    unless upload.note.nil?
      title = t("#{prefix}.note", :title => upload.note.title).html_safe
    end
    unless upload.evensong.nil?
      title = t("#{prefix}.evensong", :title => upload.evensong.title).html_safe
    end
    title
  end

  def kd(text)
    Kramdown::Document.new(text).to_html.html_safe
  end

  def msgtype_line(type)
    case type
      when 'info'
        title = "INFO"
        icon = 'icon-info-sign'
      when 'warning'
        title = "WARNING"
        icon = 'icon-warning-sign'
      else
        title = "ERROR"
        icon = 'icon-exclamation-sign'
    end

    "<a rel='tooltip' title='#{title}'><i class='#{icon}'></i></a>".html_safe
  end

  def active_line(flag)
    case flag
      when true
        title = "ACTIVE"
        icon = 'icon-ok'
      else
        title = "INACTIVE"
        icon = 'icon-off'
    end

    "<a rel='tooltip' title='#{title}'><i class='#{icon}'></i></a>".html_safe
  end
end
