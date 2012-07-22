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
puts "== Testing Strings ==".color('m')
pp(table = Swak::Table.read(fn("ints_header.tsv")))
raise unless Swak::Table.read(fn("ints_header.tsv"), :delim => /\s+/) == table
hh = {:has_header => true}
raise if Swak::Table.read(fn("ints_header.tsv"), hh) == table
raise unless hh[:header].is_a?(String)
puts "Output opts from header: #{hh.inspect}"

# Happy case integer
puts "== Testing Integer ==".color('m')
pp(table=Swak::Table.read(fn("ints.tsv"), :type => Integer))
raise unless table[0][0].is_a?(Integer)
raise unless Swak::Table.read(fn("ints_header.tsv"), :type => Integer, :has_header => true) == table

# Happy case float
puts "== Testing SmartRow ==".color('m')
pp(table = Swak::Table.read(fn("floats.tsv"), :type => Float))
raise unless table[0][0].is_a?(Float)
raise unless Swak::Table.read(fn("floats_header.tsv"), :type => Float, :has_header => true) == table

# Happy case smart float
puts "== Testing SmartRow ==".color('m')
table = Swak::Table.read(fn("floats_header.tsv"), :smart => true)
raise unless table[0].is_a?(Swak::Table::SmartRow)
raise unless Swak::Table.read(fn("floats_header.tsv"), :smart => true)[0]["col1"].is_a?(String)
puts "OK"


begin 
  puts "== Testing for error ==".color('m')
  pp Swak::Table.read(fn("floats_header.tsv"), :type => Float)
  puts "FAIL".color('r', false)
rescue Exception => e
  puts "OK! (#{e.inspect})".color('g')
end

puts "############# Testing writing ##############"
hh = {:type => Float, :has_header => true}
table =  Swak::Table.read(fn("floats_header.tsv"), hh)

file = fn("out.tsv")

# Happy cases
puts "== Testing as tab-delim, strings, no header) ==".color("m") 
Swak::Table.write(table, file)
puts File.read(file)

puts "== Testing as with header ==".color("m") 
Swak::Table.write(table, file, {:header => hh[:header].split})
puts File.read(file)

puts "== Testing as header, commas ==".color("m") 
Swak::Table.write(table, file, {:header => hh[:header].split, :delim => ","})
puts File.read(file)

puts "== Testing as format %f ==".color("m") 
Swak::Table.write(table, file, {:header => hh[:header], :fmt => "%f"})
puts File.read(file)

puts "== Testing as format %.1f ==".color("m") 
Swak::Table.write(table, file, {:header => hh[:header], :fmt => "%.1f"})
puts File.read(file)

begin 
  puts "== Testing for error ==".color("m") 
  Swak::Table.write(table, file, {:fmt => Integer})
  puts "FAIL".color('r')
rescue Exception => e
  puts "OK! (#{e.inspect})".color('g')
end

File.delete(file)
