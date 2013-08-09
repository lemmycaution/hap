module Hap
  module Helpers
    module Heroku
      
      protected
      
      def get_env_var_or_ask_user key, desc = nil
        val = ENV[key] || ask_user(desc || key)        
        set_env_var(key, val) unless ENV[key]
        val
      end
      
      def api_key
        @api_key ||= get_env_var_or_ask_user "HEROKU_API_KEY", "heroku api key"
      end
      
      def heroku_account
        @heroku_account ||= get_env_var_or_ask_user "HEROKU_ACCOUNT", "heroku:accounts plugin account name"        
      end
      
      def has_accounts_plugin?
        run "heroku plugins | grep accounts", capture: true
      end
      
      def has_remote_repository?
        run "git remote show | grep production", capture: true
      end
      
      def create_app name
        
        begin
          
          @app = App.new name
          return @app if @app.exists?
    
          create_file @app.create!(self.api_key).file do
            Oj.dump(@app.data)
          end
          
          raise Thor::Error, "App could not created" unless @app.exists?          
          
          inside "#{@app_path}/#{Hap::DEPLOYMENT_DIR}/#{name}" do
            git_init
            git_remote_add @app
          end    
          
          @app
          
        rescue Exception => e
          
          @app.destroy! if @app && @app.exists?
          raise e
          
        end 
      end
    
      def delete_app name  
        App.new(name).destroy! api_key
      end
      
      private
      
    
    end
  end
end