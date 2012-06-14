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

    def Interval.lists_intersect(list1, list2)
      list1 = list1.sort_by(&Interval::sort_by_start)
      list2 = list2.sort_by(&Interval::sort_by_end)

      results = []

      return results if list1.size == 0 || list2.size == 0

      j = 0
      list1.each_with_index do |int1, i|
        next if int1[1] <= list2[j][0] # int1 is strictly less than int2, so walk int1 forward

        # int2 is strictly less than int1, walk it forward
        while j < list2.size && list2[j][1] <= int1[0]
          j += 1
        end

        break if j >= list2.size

        results << [int1, list2[j]] if intersect(int1, list2[j])
      end

      return results
    end

  end
end
