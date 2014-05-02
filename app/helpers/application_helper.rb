module ApplicationHelper
  def link_with_icon(icon, text, white=false)
    "<span class='glyphicon glyphicon-#{icon} #{'white' if white}'></span>&nbsp;#{text}".html_safe
  end

  def clear_button(title, link)
    "<a href='#{link}' class='btn btn-default'>#{title} <span class='glyphicon glyphicon-remove-circle'></span></a>".html_safe
  end

  def clear_search_button(field)
    unless params[field].blank?
      clear_button params[field], typedsearch_path(request.GET.reject { |k, v| k == field.to_s })
    end
  end

  def has_search?
    params.include?(:search) || params.include?(:composer) || params.include?(:genre) || params.include?(:period) || params.include?(:language) || params.include?(:instrument) || params.include?(:voice)
  end

  def search_link(key, value, type='all')
    if value.blank?
      return ''
    end

#    link_to link_with_icon('search', value), typedsearch_path(:type => type, :"#{key}" => value)
    link_to value, typedsearch_path(:type => type, :"#{key}" => value)
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

  def sorted_scoped(scoped, ids)
    scoped.where(id: ids).order("find_in_array(id, #{ids.to_postgres_array})")
  end

  def upload_back_item(path)
    Upload.search_path(path)
  end

  def upload_back_link(path)
    upload = upload_back_item(path)

    if upload
      if upload.note
        link_to "#{t('page.note.title')}: #{upload.note.title}", note_path(upload.note)
      else
        link_to "#{t('page.evensong.title')}: #{upload.evensong.title}", evensong_path(upload.evensong)
      end
    end
  end

  def get_icon_for_path(path)
    ext = path.gsub(/.*\./, '').downcase.to_sym

    ext = :default unless DROPBOX_FILE_ICONS.has_key? ext

    DROPBOX_FILE_ICONS[ext]
  end

  def short_media_link(upload, source)
    media = upload.media

    if media.nil?
      link_to "<i class='#{get_icon_for_path(upload.path)}'></i>".html_safe, source, :rel => 'popover', :data => {:container => 'body', :toggle => 'popover', :trigger => 'hover', :title => upload.display_name, :content => t('upload.not.available')}
    else
      link_to "<i class='#{get_icon_for_path(upload.path)}'></i>".html_safe, upload.media, :rel => 'tooltip', :title => upload.display_name
    end
  end

  def media_link(upload, refresh_cache=false)
    if refresh_cache
      upload.media(true)
    end

    unless upload.media
      return "#{upload.display_name} - #{t('media.file.missing')}"
    end

    link_to "<i class='#{get_icon_for_path(upload.path)}'></i>".html_safe + upload.display_name, upload.media
  end

  def upload_title(prefix, upload)
    title = ''
    unless upload.note.nil?
      title = t("#{prefix}.note", :title => upload.note.title).html_safe
    end
    unless upload.evensong.nil?
      title = t("#{prefix}.evensong", :title => upload.evensong.title).html_safe
    end
    title
  end
end
