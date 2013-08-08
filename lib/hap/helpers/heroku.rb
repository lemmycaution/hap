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
        @app = heroku_client.post_app(name: nil).body
        raise "Endpoint has not been created" unless app["id"]
    
        if endpoint == Hap::FRONT_END
          heroku_client.put_config_vars(app["name"], {
            "BUILDPACK_URL" => 'https://github.com/kiafaldorius/haproxy-buildpack'
          }) 
        end
    
        create_file "#{app_path}/deploy/#{endpoint}/heroku.json" do
          Oj.dump(app)
        end
          
        inside("#{app_path}/deploy/#{endpoint}",verbose: true) do
          run "git init" unless File.exists?(".git")
          run "git remote add #{endpoint} #{app["git_url"]}"                            
        end            
      end
    
      def delete_app endpoint  
        data = "#{app_path}/deploy/#{endpoint}/heroku.json"
        app = Oj.load(File.read(data))
        heroku_client.delete_app app["name"]
      end
      
      private
      
      def app_path
        Dir.pwd
      end
      
      def app; @app end
      
      def heroku_client
        api_key = ENV['HEROKU_API_KEY'] || ask_user("heroku api key")        
        save_api_key api_key unless ENV['HEROKU_API_KEY']
        
        @heroku_client ||= Heroku::API.new(api_key: api_key)
      end
      
      def save_api_key api_key
        env = "#{app_path}/.env"
        if File.exists?(env)
          if File.read(env).include?("HEROKU_API_KEY")
            gsub_file env, /HEROKU_API_KEY=*.?/, "HEROKU_API_KEY=#{api_key}"
          else
            append_file env,"HEROKU_API_KEY=#{api_key}"
          end
        else
          create_file env,"HEROKU_API_KEY=#{api_key}"
        end
        ENV['HEROKU_API_KEY'] = api_key            
      end
    
    end
  end
end