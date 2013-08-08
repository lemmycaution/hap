module Hap
  module Helpers    
    module Endpoint
              
      protected
      
      def endpoints(with_servers = false)
        @endpoints ||= begin
          Array.new.tap{ |endpoints| 
            Dir.glob("#{Hap::ENDPOINTS_DIR}/**/*.rb").each_with_index do |file,index|
              return unless File.file? file
                
              path = file.gsub(/#{Hap::ENDPOINTS_DIR}|\.rb/,"")[1..-1]
              name = path.parameterize.underscore
              servers = []
              host = nil
              
              if with_servers
                servers = [{ 
                  address: address(path), port: port(name, index), 
                  options: Hap::HAPROXY_BACKEND_SERVER_OPTIONS,
                  type:    Hap::DEFAULT_PROCESS_TYPE 
                }]
                host = get_host(path)
              end

              endpoints << {file: file, path: path, name: name, host: host, servers: servers}
            end
          }
        end  
      end
      
      def deployed? endpoint
        App.new(endpoint[:path]).exists?
      end
      
      def deploy_dir endpoint
        endpoint[:file].gsub(Hap::ENDPOINTS_DIR, Hap::DEPLOYMENT_PATH)
      end
      
      private
    
      def to
        @to ||= ActiveSupport::StringInquirer.new(env)
      end
      
      def target
        @target ||= to.production? ? Hap::DEPLOYMENT_DIR : Hap::RUNTIME_DIR
      end

      def get_host path
        to.production? ? address(path) : Hap::DEVELOPMENT_HOST
      end

      def address path
        
        if to.production?
          
          app = App.new(path)
          
          # raise Thor::Error, "App has not been created yet, try $ hap create [APP] or $ hap deploy" unless app.exists?          
          app.create!(api_key) unless app.exists?
          
          app["domain_name"]["domain"]
          
        else
          "0.0.0.0"
          
        end      
                  
      end

      def port name, index
        to.production? ? Hap::DEFAULT_TCP_PORT : next_port(name,index).to_s
      end
    
      def next_port name, index
        if ports[name]
          ports[name] += 1
        else
          ports[name] = ([index,1].max * 1000) + 5000
        end  
      end

      def ports
        @ports ||= {}
      end

    end
  end
end