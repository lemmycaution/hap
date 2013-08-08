module Hap
  module Generators
    class Gemfile < Thor::Group
  
      include Hap::Helpers     

      argument :app, required: true
      argument :env, default: Hap.env
      class_option :force, default: true
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def create_cfg_file
        template "templates/config/#{Hap::BACK_END}/Gemfile.erb", target_file
      end
      
      protected
      
      def target_file
        @target_file ||= "#{Hap.app_root}/#{Hap::DEPLOYMENT_DIR}/#{app}/Gemfile"
      end
  
    end
    
  end
end
