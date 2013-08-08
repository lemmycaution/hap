module Hap
  
  class CLI < Thor  
      
    include Hap::Helpers::Heroku              
    include Hap::Helpers::Endpoints    
    include Hap::Helpers::Git        
      
    def self.source_root
      Hap.app_root
    end       
      
    if File.exists?("#{Hap.app_root}/server.rb")
      
      desc "endpoint [NAME]", "Creates new endpoint"
      def endpoint(*args)
        invoke "hap:generators:endpoint_generator"
      end
      
      desc "server", "Starts Hap server"
      def server(*args)
        invoke "hap:generators:haproxy_config_generator"        
        invoke "hap:generators:procfile_generator"                
        system "foreman start -f tmp/#{Hap::FRONT_END}/Procfile -d ."
      end      
      
      desc "create [ENDPOINT]", "Creates Heroku app for endpoint"
      def create(endpoint, *args)
        create_app endpoint
      end  
      
      desc "delete [ENDPOINT]", "Deletes Heroku app for endpoint"
      def delete(endpoint, *args)
        delete_app endpoint
      end    
      
      desc "account [HEROKU_ACCOUNT]", "Sets default heroku account if heroku:accounts plugin available"
      def account(account)
        if has_accounts = run("heroku plugins | grep accounts")
          
          set_env_var "HEROKU_ACCOUNT", account
        
          if File.exists? "#{Hap.app_root}/deploy/#{Hap::FRONT_END}"
            inside("#{Hap.app_root}/deploy/#{Hap::FRONT_END}",verbose: true) do
              run "heroku accounts:set #{account}"
            end
          end
          Dir.glob("endpoints/**/*").each do |path|  
            if File.file? path && File.exists?("#{Hap.app_root}/deploy/#{path.gsub(/endpoints|\.rb/,"")}")
              inside("#{Hap.app_root}/deploy/#{path.gsub(/endpoints|\.rb/,"")}",verbose: true) do
                run "heroku accounts:set #{account}"
              end        
            end
          end
        end           
      end
      
      desc "deploy", "Deploys to heroku" 
      def deploy(*args)
        old_env = Hap.env
        Hap.env = "production"
        
        create_app Hap::FRONT_END
        Hap::Generators::ProcfileGenerator.start [Hap::FRONT_END, "production"]
        Hap::Generators::HaproxyConfigGenerator.start ["production"]
        bundle_and_git Hap::FRONT_END
        
        endpoints.each do |endpoint|
          
          create_app endpoint[:path]
          
          filename = File.basename(endpoint[:source])
          
          Hap::Generators::ProcfileGenerator.start [endpoint[:path], "production"]
          
          copy_file "endpoints/#{endpoint[:path]}.rb", "deploy/#{endpoint[:path]}/#{filename}"
          copy_file "config/Gemfile.backend", "deploy/#{endpoint[:path]}/Gemfile"
          
          bundle_and_git endpoint[:path]
          
        end
        
        Hap.env = old_env
      end
      
    else
      
      desc "new [PATH]", "Creates new Hap App"
      def new(*args)
        invoke "hap:generators:install_generator"
      end
      
    end
      
    private
      
    def env
      Hap.env
    end     

  end

end