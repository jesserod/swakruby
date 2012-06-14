require "./" + File.dirname(__FILE__) + "/../lib/swak"

list1 = [[1, 3], [12, 14], [2, 4], [13, 15], [5, 10]]
list2 = [[2, 4], [13, 15], [2, 6], [0,1], [4.5, 4.9]]

require 'pp'
puts "Lists"
pp list1
pp list2
puts
puts "Intersection..."
pp Swak::Interval.lists_intersect(list1, list2)
