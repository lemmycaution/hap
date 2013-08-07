require 'thor/group'
require 'thor/actions'

module Hap
  module Generators
    class InstallGenerator < Thor::Group
  
      include Thor::Actions
      
      argument :name
      
      def self.source_root
        Hap.root
      end

      def copy_app_template
        directory "#{File.dirname(__FILE__)}/templates/app", name
      end
  
    end
    
  end
end