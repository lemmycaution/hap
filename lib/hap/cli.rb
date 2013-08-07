require 'thor'
require "hap/generators/install_generator"

module Hap
  class CLI < Thor
    register(Hap::Generators::InstallGenerator, 'new', 'new [PATH]', 'Creates new Hap App.')
  end
end