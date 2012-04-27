require File.join(File.dirname(__FILE__), '.', 'logger')

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

#######################################################
#######################################################

class Object
  def is_i?
    true if Integer(self) rescue false
  end

  def is_f?
    true if Float(self) rescue false
  end

  def to_i_strict
    if is_i?
      return to_i
    else
      raise "String '#{self}' cannot be converted to an int"
    end
      
  end

  def to_f_strict
    if is_f?
      return to_f
    else
      raise "String '#{self}' cannot be converted to a float"
    end
  end
end

class NilClass
  undef_method(:is_i?)
  undef_method(:is_f?)
  undef_method(:to_i_strict)
  undef_method(:to_f_strict)
  undef_method(:to_f)
  undef_method(:to_i)
end

class Float
  def is_i?
    return self == self.to_i
  end
end


#######################################################
#######################################################


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

  def argmax
    max_i = 0
    max_val = self[max_i]

    self.each_with_index do |x, i|
      if x > max_val
        max_val = x
        max_i = i
      end
    end

    return max_i
  end

  def argmin
    min_i = 0
    min_val = self[min_i]

    self.each_with_index do |x, i|
      if x < min_val
        min_val = x
        min_i = i
      end
    end

    return min_i
  end
end 
