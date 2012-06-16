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

puts "Intersection1..."
itxn =  Swak::Interval.lists_intersect_nonoverlap(list1, list2)
for pair in itxn
  puts pair.inspect
end

puts
puts "Intersection2..."
itxn =  Swak::Interval.lists_intersect(list1, list2)
for pair in itxn
  puts pair.inspect
end

puts
puts "Brute force"
itxn = Swak::Interval.lists_intersect_brute(list1, list2)
for pair in itxn
  puts pair.inspect
end

puts
puts "Random tests... will tell you if failure"
for i in 1...1000
  l1 = []
  l2 = []
  100.times { l1 << [rand(100), rand(100)].sort }
  100.times { l2 << [rand(100), rand(100)].sort }

  if Swak::Interval.lists_intersect_brute(list1, list2).sort != Swak::Interval.lists_intersect(list1, list2).sort
    raise "Don't match!\n#{l1.inspect}\n#{l2.inspect}" 
  end
end

puts "PASSed random tests!"
