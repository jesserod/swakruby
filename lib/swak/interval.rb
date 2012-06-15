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
    def Interval.nonoverlap_list_intersects_other_list(list1, list2)
      list1 = list1.sort_by(&Interval::sort_by_start)
      list2 = list2.sort_by(&Interval::sort_by_start)

      results = []

      return results if list1.size == 0 || list2.size == 0

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

  end
end
