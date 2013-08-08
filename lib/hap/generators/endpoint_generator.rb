require 'thor/group'
require 'thor/actions'

module Hap
  module Generators
    class EndpointGenerator < Thor::Group
  
      include Thor::Actions
      
      argument :name
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def copy_endpoint_template
        template("#{File.dirname(__FILE__)}/templates/endpoint.erb", "#{Dir.pwd}/endpoints/#{name}.rb")
      end
      
      private
      
      def modules
        @modules ||= name.split("/").tap{|a| a.pop }
      end
      
      def has_module?
        @has_module ||= name.include?("/")
      end
      
      def class_name
        @class_name ||= name.split("/").last
      end
      
    end
    
  end
end