$:.unshift File.dirname( __FILE__)

# real time stdout
$stdout.sync = true
# $stderr.sync = true

require "bundler/gem_tasks"

# ENV vars
if File.exists?(".env")
  Hash[File.read(".env").
    gsub("\n\n","\n").
    split("\n").
    compact.map{|v| v.split("=")}].
    each { |k,v| ENV[k] = v }
end

# Bundling
require 'bundler'
Bundler.setup
Bundler.require