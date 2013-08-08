require 'active_support/concern'
require 'oj'
require 'hap/heroku_client'

module Hap
  module Generators
    module Helpers
      module HerokuHelper
        extend ActiveSupport::Concern
      
        included do
          include Hap::HerokuClient        
        end
  
        private
      
        def heroku_client
          api_key = ENV['HEROKU_API_KEY'] || get_option("heroku api key")        
          save_api_key api_key
          @heroku_client ||= Heroku::API.new(api_key: api_key)
        end
      
        def save_api_key key
          if File.exists?(env_path)
            if File.read(env_path).include?("HEROKU_API_KEY")
              gsub_file env_path, /HEROKU_API_KEY=*.?/, "HEROKU_API_KEY=#{api_key}"
            else
              append_file env_path,"HEROKU_API_KEY=#{api_key}"
            end
          else
            create_file env_path,"HEROKU_API_KEY=#{api_key}"
          end
        end
      
        def env_path
          "#{Dir.pwd}/#{path}/.env"
        end
      
      end
    end
  end
end