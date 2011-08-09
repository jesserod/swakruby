class String
  AnsiMap = {"k" => 0,
             "r" => 1,
             "g" => 2,
             "y" => 3,
             "b" => 4,
             "m" => 5,
             "c" => 6,
             "w" => 7,
             "d" => 9}

  def color(color, fg=true)
    raise "Illegal color" unless AnsiMap.include?(color)
    color_int = AnsiMap[color]
    return "[#{fg ? 3 : 4}#{color_int}m#{self}[#{fg ? 3 : 4}9m"
  end

end
