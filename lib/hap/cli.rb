module Hap
  
    class CLI < Thor  
      
      include Hap::Helpers::Heroku              
      include Hap::Helpers::Deploy    
      
      def self.source_root
        Hap.app_root
      end       
    
      desc "new [PATH]", "Creates new Hap App"
      def new(path, options = {})
        invoke "hap:generators:install_generator"
      end
      
      desc "endpoint [NAME]", "Creates new endpoint"
      def endpoint(name, options = {})
        invoke "hap:generators:endpoint_generator"
      end
      
      desc "server", "Starts Hap server"
      def server(options = {})
        invoke "hap:generators:haproxy_config_generator"        
        invoke "hap:generators:procfile_generator"                
        system "foreman start -f tmp/#{Hap::FRONT_END}/Procfile -d ."
      end      
      
      desc "create [ENDPOINT]", "Creates Heroku app for endpoint"
      def create(endpoint, options = {})
        create_app endpoint
      end  
      
      desc "delete [ENDPOINT]", "Deletes Heroku app for endpoint"
      def delete(endpoint, options = {})
        delete_app endpoint
      end    
      
      desc "deploy", "Deploys to heroku" 
      def deploy(options = {})
        invoke "hap:generators:procfile_generator", [Hap::FRONT_END,"production"]
        invoke "hap:generators:haproxy_config_generator", ["production"]        
        endpoints.each do |endpoint|
          invoke "hap:generators:procfile_generator", [endpoint[:path][1..-1], "production"]                    
          copy_file "#{endpoint[:source]}", "deploy/#{endpoint[:path]}/#{File.basename(endpoint[:path])}.rb"
          copy_file "config/Gemfile.backend", "deploy/#{endpoint[:path]}/Gemfile"
        end
      end

    end

end