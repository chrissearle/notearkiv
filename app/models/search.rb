class Search
  def self.search(search_param)
    {
        :notes => Note.search(search_param).ordered.preloaded,
        :evensongs => Evensong.search(search_param).ordered.preloaded
    }
  end
end
