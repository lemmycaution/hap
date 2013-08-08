module Hap
  
    class CLI < Thor  
      
      include Hap::Helpers::Heroku              
      include Hap::Helpers::Deploy    
      
      def self.source_root
        Hap.app_root
      end       
    
      desc "new [PATH]", "Creates new Hap App"
      def new(*args)
        invoke "hap:generators:install_generator"
      end
      
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
      
      desc "deploy", "Deploys to heroku" 
      def deploy(*args)
        old_env = Hap.env
        Hap.env = "production"
        
        invoke :create, [Hap::FRONT_END]
        invoke "hap:generators:procfile_generator", [Hap::FRONT_END]
        invoke "hap:generators:haproxy_config_generator", ["production"]
        inside "deploy/#{Hap::FRONT_END}" do
          Bundler.with_clean_env do
            run "bundle install", verbose: false
          end
          run "git add ."
          run "git commit -am 'Auto deploy at #{Time.now}'"
          run "git push #{Hap::FRONT_END} master --force"

        end
        
        endpoints(false).each do |endpoint|
          klass = endpoint[:path][1..-1]
          filename = File.basename(endpoint[:source])
          invoke :create, [klass]
          invoke "hap:generators:procfile_generator", [klass, "production"]                    
          copy_file endpoint[:source], "deploy/#{klass}/#{filename}"
          copy_file "config/Gemfile.backend", "deploy/#{klass}/Gemfile"
          inside "deploy/#{klass}" do
            Bundler.with_clean_env do
              run "bundle install", verbose: false
            end
            run "git add ."
            run "git commit -am 'Auto deploy at #{Time.now}'"
            run "git push #{klass} master --force"
          end
        end
        
        Hap.env = old_env
      end
      
      private
      
      def env
        Hap.env
      end     

    end

end