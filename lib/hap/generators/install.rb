module Hap
  module Generators
    class Install < Thor::Group
  
      include Hap::Helpers
      
      argument :path,       required: true
      class_option :bundle, default: false
      class_option :remote, default: false      
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def create_app_directory_structure
        directory("templates/app", path)
        empty_directory "#{app_path}/#{Hap::DEPLOYMENT_DIR}"
        empty_directory "#{app_path}/#{Hap::RUNTIME_DIR}"
        empty_directory "#{app_path}/app/endpoints"
        empty_directory "#{app_path}/config"
        Hap.app_root = app_path
      end
      
      def install_bundle
        return unless options[:bundle]
        inside(app_path) do
          Bundler.with_clean_env do
            run "bundle install", capture: true
          end
        end
      end
      
      def init_git
        inside(app_path) do
          git_init
        end
      end
      
      def create_remote_app
        create_app Hap::FRONT_END if options[:remote]
      end
      
      private
      
      def app_path
        "#{Dir.pwd}/#{path}"
      end
      
    end
    
  end
end