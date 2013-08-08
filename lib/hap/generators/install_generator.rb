module Hap
  module Generators
    class InstallGenerator < Thor::Group
  
      include Thor::Actions
      include Helpers::UserInput
      include Helpers::Heroku
      
      argument :path
      class_option :bundle, default: false
      class_option :remote, default: false      
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def copy_app_template
        directory("templates/app", path)
      end
      
      def install_bundle
        if options[:bundle]
          inside(app_path, verbose: true) do
            Bundler.with_clean_env do
              run "bundle install", capture: true
            end
          end
        end
      end
      
      def init_git
        inside(app_path, verbose: true) do
          run "git init", capture: true
          run "git add .", capture: true
          run "git commit -am 'initial commit'", capture: true
        end
      end
      
      def create_remote_app
        if options[:remote]
          create_app Hap::FRONT_END
        end
      end
      
      private
      
      def app_path
        "#{Dir.pwd}/#{path}"
      end
      
    end
    
  end
end