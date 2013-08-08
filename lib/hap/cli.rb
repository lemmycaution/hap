require 'thor'
require "hap/generators/install_generator"
require "hap/generators/haproxy_config_generator"
require "hap/generators/procfile_generator"
require "hap/generators/endpoint_generator"

module Hap
  class CLI < Thor
    
    register(Hap::Generators::InstallGenerator, 'new', 'new [PATH]', 'Creates new Hap App.')

    register(Hap::Generators::EndpointGenerator, 'endpoint', 'endpoint [NAME]', 'Creates an endpoint.')
        
    desc "server", "generates necessary files and runs servers"
    def server
      Hap::Generators::HaproxyConfigGenerator.start
      Hap::Generators::ProcfileGenerator.start ["frontend"]
      system 'foreman start -f tmp/frontend/Procfile -d .'      
    end
    
  end
end