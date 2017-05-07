require 'scheduler'

scheduler = Scheduler.new

puts scheduler.allocations.lazy.first
