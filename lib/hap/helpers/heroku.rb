require 'heroku-api'
require 'oj'

module Hap
  module Helpers
    module Heroku
      
      extend ActiveSupport::Concern
    
      included do        
        include Helpers::UserInput
        include Thor::Actions
      end

      protected
      
      def create_app endpoint
        begin
          json = "#{app_path}/deploy/#{endpoint}/heroku.json"
          return if File.exists?(json)
          @app = heroku_client.post_app(name: nil).body
          raise "Endpoint has not been created" unless app["id"]
    
          if endpoint == Hap::FRONT_END
            heroku_client.put_config_vars(app["name"], {
              "BUILDPACK_URL" => Hap::BUILDPACK_URL
              }) 
          end
    
          create_file json do
            Oj.dump(app)
          end
          
          inside("#{app_path}/deploy/#{endpoint}",verbose: true) do
            run "git init" unless File.exists?(".git")
            run "git remote add #{endpoint} #{app["git_url"]}"   
            if has_accounts = run("heroku plugins | grep accounts")
              heroku_account = ENV['HEROKU_ACCOUNT'] ||= ask_user("heroku account")  
              run "heroku accounts:set #{heroku_account}"          
            end                                     
          end    
        rescue Exception => e
          heroku_clint.delete_app @app["name"] if @app
          raise e
        end 
      end
    
      def delete_app endpoint  
        data = "#{app_path}/deploy/#{endpoint}/heroku.json"
        if File.exists?(data)
          app = Oj.load(File.read(data))
          heroku_client.delete_app app["name"]
        end
      end
      
      private
      
      def app_path
        Dir.pwd
      end
      
      def app; @app end
      
      def heroku_client
        api_key = ENV['HEROKU_API_KEY'] || ask_user("heroku api key")        
        set_env_var("HEROKU_API_KEY", api_key) unless ENV['HEROKU_API_KEY']
        
        @heroku_client ||= ::Heroku::API.new(api_key: api_key, :mock => Hap.env.test?)
      end
    
    end
  end
end