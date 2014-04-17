module ApplicationHelper
  def link_with_icon(icon, text, white=false)
    "<span class='glyphicon glyphicon-#{icon} #{'white' if white}'></span> #{text}".html_safe
  end
end
