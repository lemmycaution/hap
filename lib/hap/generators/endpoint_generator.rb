module Hap
  module Generators
    class EndpointGenerator < Thor::Group
  
      include Thor::Actions
      include Helpers::Heroku    
      
      argument :name
      class_option :remote, default: false            
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def copy_endpoint_template
        template("templates/endpoint.erb", "#{Hap.app_root}/endpoints/#{name}.rb")
      end
      
      def create_remote_app
        if options[:remote]
          create_app name
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