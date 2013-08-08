module Hap
  module Helpers
    module Heroku
      
      protected
      
      def get_env_var_or_ask_user key, desc = nil
        val = ENV[key] || ask_user(desc || key)        
        set_env_var(key, val) unless ENV[key]
      end
      
      def api_key
        get_env_var_or_ask_user "HEROKU_API_KEY", "heroku api key"
      end
      
      def heroku_account
        get_env_var_or_ask_user "HEROKU_ACCOUNT", "heroku:accounts plugin account name"        
      end
      
      def has_accounts_plugin?
        run "heroku plugins | grep accounts"
      end
      
      def has_remote_repository?
        run "git remote show | grep production"
      end
      
      def create_app name
        
        begin
          
          @app = App.new name
          return app if app.exists?
          
          app.create! api_key
          return unless app.exists?
    
          create_file app.file do
            Oj.dump(app.data)
          end
          
          inside "#{app_path}/#{Hap::DEPLOYMENT_DIR}/#{name}" do
            git_remote_add app
          end    
          
        rescue Exception => e
          
          app.destroy! if app.exists?
          raise Thor::Error, e.message
          
        end 
      end
    
      def delete_app name  
        App.new(name).destroy! api_key
      end
      
      private
      
      def app; @app end
    
    end
  end
end