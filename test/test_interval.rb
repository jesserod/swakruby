require "./" + File.dirname(__FILE__) + "/../lib/swak"

list1 = [[1, 3], [0, 1], [5, 6],  [14, 14] ]
list2 = [[2, 4], [13, 15], [0,1], [4.9, 10], [4.5, 4.6]]

require 'pp'
puts "Lists"
pp list1
pp list2
puts

puts "Lists (sorted)"
pp list1.sort_by(&Swak::Interval.sort_by_start)
pp list2.sort_by(&Swak::Interval.sort_by_start)
puts

puts "Intersection..."
itxn =  Swak::Interval.nonoverlap_list_intersects_other_list(list1, list2)
for pair in itxn
  puts pair.inspect
end
