$:.unshift File.dirname( __FILE__)

# real time stdout
$stdout.sync = true
$stderr.sync = true

# Bundling
require 'bundler'
Bundler.setup
Bundler.require
