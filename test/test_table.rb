require File.join(File.dirname(__FILE__), '..', 'lib', 'swak', 'toplevel')
require File.join(File.dirname(__FILE__), '..', 'lib', 'swak', 'table')

def fn(file_name)
  File.join(File.dirname(__FILE__), '..', 'examples', file_name)
end

require 'pp'

puts "############# Testing transpose ##############"
table = [[1,2],[3,4],[5,6]]
print "Table:              "
pp table
print "Table (transposed): "
pp Swak::Table.transpose(table)
puts

puts "############# Testing reading ##############"

# Happy cases, as strings
pp Swak::Table.read(fn("ints_header.tsv"))
pp Swak::Table.read(fn("ints_header.tsv"), :delim => /\s+/)
hh = {:has_header => true}
pp Swak::Table.read(fn("ints_header.tsv"), hh)
pp hh

# Happy case integer
pp Swak::Table.read(fn("ints.tsv"), :type => Integer)
pp Swak::Table.read(fn("ints_header.tsv"), :type => Integer, :has_header => true)

# Happy case float
pp Swak::Table.read(fn("floats.tsv"), :type => Float)
pp Swak::Table.read(fn("floats_header.tsv"), :type => Float, :has_header => true)

begin 
  print "Testing for error...  "
  pp Swak::Table.read(fn("floats_header.tsv"), :type => Float)
rescue Exception => e
  puts "OK! (#{e.inspect})"
end

puts "############# Testing writing ##############"
hh = {:type => Float, :has_header => true}
table =  Swak::Table.read(fn("floats_header.tsv"), hh)

file = fn("out.tsv")

# Happy cases
puts
Swak::Table.write(table, file, hh[:header])
puts File.read(file)

puts
Swak::Table.write(table, file, {:header => hh[:header].split})
puts File.read(file)

puts
Swak::Table.write(table, file, {:header => hh[:header].split, :delim => ","})
puts File.read(file)

puts
Swak::Table.write(table, file, {:header => hh[:header], :fmt => "%f"})
puts File.read(file)

puts
Swak::Table.write(table, file, {:header => hh[:header], :fmt => "%.1f"})
puts File.read(file)

begin 
  print "Testing for error..."
  Swak::Table.write(table, file, {:fmt => Integer})
rescue Exception => e
  puts "OK! (#{e.inspect})"
end

File.delete(file)
