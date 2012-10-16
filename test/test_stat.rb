require File.join(File.dirname(__FILE__), '..', 'lib', 'swak')

puts '########### Testing GaussianDistribution ###########'

r = Swak::Stat::GaussianDistribution.new
puts 'Generating samples'.color('m')
puts r.rand
puts r.rand
puts r.rand
puts r.rand
puts [r.rand, r.rand, r.rand].join(' ')

# This test should fail with astronomically small probability
raise if Swak::Stat::GaussianDistribution.new(0.0, 0.01).rand > 1000000.0

puts 'Testing error handling'.color('m')
begin
  Swak::Stat::GaussianDistribution.new(-1.0, -1.0)
rescue Exception => e
  puts "Got expected exception (#{e.inspect})"
end

begin
  puts 'Testing pdf'.color('m')

  raise if r.pdf(-0.5) != r.pdf(0.5)

  y = r.pdf(1.0)
  puts "pdf(1.0) = #{y}"
  raise unless 0.24 < y and y < 0.242   # Tolerate some error
end

puts 'Passed all tests'.color('g')
