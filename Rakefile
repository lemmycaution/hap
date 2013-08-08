$:.unshift File.dirname( __FILE__)

# real time stdout
$stdout.sync = true
$stderr.sync = true

require "bundler/gem_tasks"

# Test Task
task :test, [:path] do |t, args|
  
  # set environment
  ENV["RACK_ENV"] = "test"
  
  require 'hap'
  
  # include support files
  Dir.glob('spec/support/*.rb') { |f| require f }
  
  # Run them all or only one
  if ARGV.length < 2
    Dir.glob('spec/**/*_spec.rb') { |f| 
      require f.gsub("spec/","hap/").gsub("_spec","")
      require f 
    }
  else
    require "#{ARGV[1].gsub("spec/","hap/")}"    
    require "#{ARGV[1]}_spec.rb"
  end
end

task :default => ["test"]