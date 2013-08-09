require "./env"

$stderr.sync = true

# Test Task
task :test, [:path] do |t, args|
  
  # set environment
  ENV["RACK_ENV"] = "test"
  ENV['HEROKU_API_KEY']='TEST_API_KEY'
  ENV['HEROKU_ACCOUNT']='fluxproject'  
  
  require 'hap'
  
  # include support files
  Dir.glob('spec/support/*.rb') { |f| require f }
  
  # Run them all or only one
  if ARGV.length < 2
    Dir.glob('spec/**/*_spec.rb') { |f| require f }
  else
    require "#{ARGV[1]}_spec.rb"
  end
end

task :default => ["test"]