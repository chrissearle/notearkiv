module ApplicationHelper
  def link_with_icon(icon, text, white=false)
    "<span class='glyphicon glyphicon-#{icon} #{'white' if white}'></span> #{text}".html_safe
  end

  def title(page_title, show_title = true)
    title = strip_tags(page_title.to_s)

    if show_title
      content_for(:heading) { title }
    end

    content_for(:title) { "#{title} - OCHS" }
  end
end
