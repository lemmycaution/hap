require 'thor/group'
require 'thor/actions'
require 'hap/generators/helper'

module Hap
  module Generators
    class ProcfileGenerator < Thor::Group
  
      include Thor::Actions
      include Generators::Helper
      
      class_option :force, default: true
      
      def self.source_root
        Hap.root
      end

      def create_procfile
        template "config/Procfile", "tmp/frontend/Procfile"
      end
  
    end
    
  end
end