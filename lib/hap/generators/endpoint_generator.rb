require 'thor/group'
require 'thor/actions'
require 'hap/generators/helpers/user_input_helper'
require 'hap/generators/helpers/heroku_helper'

module Hap
  module Generators
    class EndpointGenerator < Thor::Group
  
      include Thor::Actions
      include Generators::Helpers::UserInputHelper      
      include Generators::Helpers::HerokuHelper      
      
      argument :name
      class_option :remote, default: false            
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def copy_endpoint_template
        template("#{File.dirname(__FILE__)}/templates/endpoint.erb", "#{Dir.pwd}/endpoints/#{name}.rb")
      end
      
      def create_remote_front_app
        if options[:remote]
          create_app name, "#{Dir.pwd}"
        end
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