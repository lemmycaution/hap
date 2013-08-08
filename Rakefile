$:.unshift File.dirname( __FILE__)

# real time stdout
$stdout.sync = true
$stderr.sync = true

require "bundler/gem_tasks"

# ENV vars
if File.exists?(".env")
  Hash[File.open(".env").read.split("\n").map{|v| v.split("=")}].each do |k,v|
    ENV[k] = v if k != "RACK_ENV"
  end
end

# Bundling
require 'bundler'
Bundler.setup
Bundler.require

# Test Task
task :test, [:path] do |t, args|
  
  # set environment
  ENV["RACK_ENV"] = "test"
  
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