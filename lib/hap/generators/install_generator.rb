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
        gsub_file "#{Dir.pwd}/#{path}/config/hap.yml", /HapApp/, name.classify
      end
      
      def install_bundle
        if options[:bundle]
          inside("#{Dir.pwd}/#{path}",:verbose => true) do
            Bundler.with_clean_env do
              run "bundle install"
            end
          end
        end
      end
      
      def init_git
        inside("#{Dir.pwd}/#{path}",:verbose => true) do
          run "git init && git add . && git commit -am 'initial commit'"
        end
      end
      
      def create_remote_front_app
        if options[:remote]
          @heroku_app = heroku_client.post_app(name: nil, buildpack: "https://github.com/kiafaldorius/haproxy-buildpack").body
          raise "App has not been created" unless @heroku_app["id"]
          
          heroku_client.put_config_vars(@heroku_app["name"], {
            "BUILDPACK_URL" => 'https://github.com/kiafaldorius/haproxy-buildpack'
          }) 
          
          inside("#{Dir.pwd}/#{path}",:verbose => true) do
            run "git remote add frontend #{@heroku_app["git_url"]}"
          end
          
          create_file "#{Dir.pwd}/#{path}/db/local/apps/frontend.json" do
            Oj.dump(@heroku_app)
          end
          
        end
      end
      
      private
      
      def name
        path.split("/").last
      end
      
    end
    
  end
end