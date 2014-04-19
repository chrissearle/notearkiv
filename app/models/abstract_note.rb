module AbstractNote
  def remove_links
    self.links.each do |link|
      link.destroy
    end
  end

  def remove_uploads
#    self.uploads.each do |upload|
#      upload.destroy
#    end
  end

  def typeahead(prefix)
    get_typeahead.map do |name|
      name and name.parameterize.split((/\W+/))
    end.flatten.select { |candidate| candidate and candidate.start_with? prefix.parameterize }.uniq
  end
end
