require 'thor/group'
require 'thor/actions'
require 'hap/generators/helpers/config_helper'

module Hap
  module Generators
    class ProcfileGenerator < Thor::Group
  
      include Thor::Actions
      include Generators::Helpers::ConfigHelper
      
      argument :app, default: "frontend"
      argument :env, default: Hap.env
      class_option :force, default: true
      
      def self.source_root
        Dir.pwd
      end

      def create_procfile
        template "config/Procfile.#{app}", "#{target_root_path}/#{app}/Procfile"
      end
      
      private
      
      def haproxy
        env == "production" ? 
        "./haproxy -f haproxy.cfg" : 
        "haproxy -f #{target_root_path}/frontend/haproxy.cfg -d -V"
      end

      def endpoints
        return [] if env == "production"
        super
      end
  
    end
    
  end
end