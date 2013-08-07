require 'thor/group'
require 'thor/actions'
require 'hap/generators/helper'

module Hap
  module Generators
    class InstallGenerator < Thor::Group
  
      include Thor::Actions
      include Generators::Helper
      
      argument :name
      
      def self.source_root
        Hap.root
      end

      def copy_app_template
        directory "templates/app" name
      end
  
    end
    
  end
end