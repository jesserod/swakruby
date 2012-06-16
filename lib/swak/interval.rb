module Swak
  module Interval
    def Interval.sort_by_end
      return Proc.new{|interval| [interval[1], interval[0]]}
    end

    def Interval.sort_by_start
      return Proc.new{|interval| [interval[0], interval[1]]}
    end

    def Interval.intersect(x,y)
      return x[0] < y[1] && x[1] > y[0]
    end

    # Assumes that boths lists dont overlap with themselves
    def Interval.lists_intersect_nonoverlap(list1, list2)
      results = []
      return results if list1.size == 0 || list2.size == 0

      list1 = list1.sort_by(&Interval::sort_by_start)
      list2 = list2.sort_by(&Interval::sort_by_start)

      for int1 in list1
        # Throw out anything in list2 that ends before int1 starts
        while list2.size > 0 && list2.first[1] <= int1[0]
          list2.shift
        end
        break if list2.size == 0
        
        # Now we know the first element of list2 ends somewhere after int1 starts
        for int2 in list2
          if int2[0] < int1[1] # It must overlap if int2 starts before int1 ends 
            results << [int1, int2]
          else
            break
          end
        end
      end

      return results
    end

    # Assumes that boths lists dont overlap with themselves
    def Interval.lists_intersect(list1, list2)
      results = []
      return results if list1.size == 0 || list2.size == 0

      list1 = list1.sort_by(&Interval::sort_by_start)
      list2 = list2.sort_by(&Interval::sort_by_end)


      # Compute the minimum of all start values at each position or after
      # This will help us terminate early after pass our query interval
      # Note: this will not help in the degenerate case when there is 1 interval that spans the entire first list
      min_starts = Array.new(list2.size, nil)
      min_starts[list2.size - 1] = list2[list2.size - 1][0]
      if list2.size >= 2
        i = list2.size - 2
        while i >= 0
          min_starts[i] = [min_starts[i+1], list2[i][0]].min
          i -= 1
        end
      end


      for int1 in list1
        while list2.size > 0 && list2.first[1] <= int1[0]
          list2.shift
          min_starts.shift
        end
        break if list2.size == 0

        list2.each_with_index do |int2, i|
          break if min_starts[i] >= int2[1] # We can stop because no intervals (this one or later) start before the current interval ends
          results << [int1, int2] if intersect(int1, int2)
        end
      end

      return results

    end

    def Interval.lists_intersect_brute(list1, list2)
      results = []
      for int1 in list1
        for int2 in list2
          results << [int1, int2] if intersect(int1, int2)
        end
      end
      return results
    end

  end
end
