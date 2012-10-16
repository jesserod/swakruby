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
  puts 'Got expected exception (#{e.inspect})'
end

puts 'Passed all tests'.color('g')
