class String
  def sql_escape
    self.gsub(/[%_'\\"]/, "\\\\\\0")
  end
end

class Array
  def to_postgres_array
    "'{" + self.inject([]) do |mem, val|
      mem << (val.kind_of?(String) ? "\"#{val.sql_escape}\"" : val)
      mem
    end.join(", ") + "}'"
  end
end