require 'thor/group'
require 'thor/actions'
require 'hap/generators/helpers/config_helper'

module Hap
  module Generators
    class ProcfileGenerator < Thor::Group
  
      include Thor::Actions
      include Generators::Helpers::ConfigHelper
      
      argument :app, default: "frontend"
      class_option :force, default: true
      
      def self.source_root
        Dir.pwd
      end

      def create_procfile
        template "config/Procfile.#{app}", "tmp/#{app}/Procfile"
      end
      
      private
      
      def endpoints
        return [] if Hap.env == "production"
        super
      end
  
    end
    
  end
end