module Hap
  
  class CLI < Thor  
      
    include Hap::Helpers              
      
    def self.source_root
      Hap.app_root
    end       
      
    unless Hap.in_app_dir?
      
      desc "new [PATH]", "Creates new Hap App"
      def new(*args)
        Hap::Generators::Install.start args
      end
      
    else  
      
      desc "endpoint [NAME]", "Creates new endpoint"
      def endpoint(*args)
        Hap::Generators::Endpoint.start args
      end

      desc "create [APP]", "Creates Heroku app"
      def create(*args)
        create_app *args
      end  
      
      desc "delete [APP]", "Deletes Heroku app"
      def delete(app, *args)
        delete_app app
      end    
      
      desc "account [HEROKU_ACCOUNT]", "Sets default heroku account if heroku:accounts plugin available"
      def account(account)
        if has_accounts_plugin?
          
          set_env_var "HEROKU_ACCOUNT", account
        
          if File.exists? Hap::DEPLOYED_FRONTEND
            inside Hap::DEPLOYED_FRONTEND do
              run "heroku accounts:set #{account}"
            end
          end
          
          endpoints.each do |endpoint|
            next unless deployed? endpoint
            inside deploy_dir(endpoint) do
              run "heroku accounts:set #{account}"
            end        
          end
          
        end           
      end
      
      desc "server", "Starts Hap server"
      def server(*args)
        Hap::Generators::Haproxy.start args
        Hap::Generators::Procfile.start args         
        system "foreman start -f #{Hap::RUNTIME_DIR}/#{Hap::FRONT_END}/Procfile -d ."
      end 
      
      desc "deploy", "Deploys to heroku" 
      def deploy(*args)
        old_env = Hap.env
        Hap.env = "production"
        
        # Deploy Frontend
        create_app Hap::FRONT_END
        
        Hap::Generators::Procfile.start [Hap::FRONT_END, "production"]
        Hap::Generators::Haproxy.start ["production"]
        bundle_and_git Hap::FRONT_END
        
        # Deploy Backend
        endpoints.each do |endpoint|
          
          create_app endpoint[:path]
          
          Hap::Generators::Procfile.start [endpoint[:path], "production"]
          Hap::Generators::Gemfile.start [endpoint[:path], "production"]          
          
          copy_file endpoint[:file], deploy_dir(endpoint)

          bundle_and_git endpoint[:path]
          
        end
        
        Hap.env = old_env
      end
      
    end
      
    private
      
    def env
      Hap.env
    end     

  end

end