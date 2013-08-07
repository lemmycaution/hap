require 'thor/group'
require 'thor/actions'
require 'hap/generators/helper'

module Hap
  module Generators
    class ProcfileGenerator < Thor::Group
  
      include Thor::Actions
      include Generators::Helper
      
      argument :app, default: "frontend"
      class_option :force, default: true
      
      def self.source_root
        Hap.root
      end

      def create_procfile
        template "config/Procfile.#{app}", "tmp/#{app}/Procfile"
      end
      
      private
      
      def endpoints
        return [] if env == "production"
        super
      end
  
    end
    
  end
end