# coding: UTF-8

class String
  def to_latin1
    self.encode "ISO-8859-1", "UTF-8"
  end
end
