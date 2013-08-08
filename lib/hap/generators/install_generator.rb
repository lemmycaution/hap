require 'thor/group'
require 'thor/actions'
require 'hap/generators/helpers/user_input_helper'
require 'hap/generators/helpers/heroku_helper'

module Hap
  module Generators
    class InstallGenerator < Thor::Group
  
      include Thor::Actions
      include Generators::Helpers::UserInputHelper      
      include Generators::Helpers::HerokuHelper
      
      desc "Generates new blank Hap App"
      argument :path
      class_option :bundle, default: false
      class_option :remote, default: false      
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def copy_app_template
        directory("templates/app", path)
      end
      
      def rename_app
        gsub_file "#{root_path}/config/hap.yml", /HapApp/, name.classify
      end
      
      def install_bundle
        if options[:bundle]
          inside(root_path,:verbose => true) do
            Bundler.with_clean_env do
              run "bundle install"
            end
          end
        end
      end
      
      def init_git
        inside(root_path,:verbose => true) do
          run "git init && git add . && git commit -am 'initial commit'"
        end
      end
      
      def create_remote_front_app
        if options[:remote]
          create_app "frontend", root_path
        end
      end
      
      private
      
      def name
        path.split("/").last
      end
      
      def root_path
        "#{Dir.pwd}/#{path}"
      end
      
    end
    
  end
end