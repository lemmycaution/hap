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
          inside(app_path,verbose: true) do
            Bundler.with_clean_env do
              run "bundle install", verbose: false
            end
          end
        end
      end
      
      def init_git
        inside(app_path, verbose: true) do
          run "git init && git add . && git commit -am 'initial commit'", verbose: false
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