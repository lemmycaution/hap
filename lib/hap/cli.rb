require 'thor'
require "hap/generators/install_generator"

module Hap
  class CLI < Thor
    
    register(Hap::Generators::InstallGenerator, 'new', 'new [PATH]', 'Creates new Hap App.')
    
    desc "server", "generates necessary files and runs servers"
    def server
      Hap::Generators::HaproxyConfigGenerator.start
      Hap::Generators::ProcfileGenerator.start      
      system 'foreman start -f tmp/frontend/Procfile -d .'      
    end
    
  end
end