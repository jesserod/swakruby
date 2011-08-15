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

  def is_i?
    true if Integer(self) rescue false
  end

  def is_f?
    true if Float(self) rescue false
  end

end

class Array

	def hist
		h = {}
		for item in self
			h[item] ||= 0
			h[item] += 1
		end
		return h
	end

	def shuffle!
		sort_by {rand}
		return self
	end
	
	def shuffle
		return dup().sort_by {rand}
	end

	def sum
		total = 0
		for item in self
			total += item
		end
		return total
	end

	def avg
		return sum.to_f / self.length
	end

	# Sample variance
	def variance
		average = avg()
		variance = 0
		for item in self
			diff = item - average
			variance += diff * diff
		end
		return variance / (self.length - 1)
	end

	def stddev
		return Math.sqrt(self.variance())
	end

	def mean
		return self.avg
	end
end 
