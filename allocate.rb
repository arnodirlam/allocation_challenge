require_relative 'lib/scheduler'

scheduler = Scheduler.new

puts "Starting at #{Time.now.strftime('%H:%M:%S')}..."
scheduler.allocations.lazy.each do |allocation|
  puts "[#{Time.now.strftime('%H:%M:%S')}] #{allocation}"
end
