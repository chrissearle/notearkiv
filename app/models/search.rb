class Search
  def self.search(search_param)
    {
        :notes => Note.search(search_param).preloaded,
        :evensongs => Evensong.search(search_param).preloaded
    }
  end
end
