module Hap
  module Generators
    class Endpoint < Thor::Group
  
      include Hap::Helpers    
      
      argument :name, required: true
      class_option :remote, default: false            
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def copy_endpoint_template
        template("templates/endpoint.erb", "#{Hap.app_root}/#{Hap::ENDPOINTS_DIR}/#{name}.rb")
      end
      
      def create_remote_app
        create_app name if options[:remote]
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