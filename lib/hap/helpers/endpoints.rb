module Hap
  module Helpers    
    module Endpoints
      
      extend ActiveSupport::Concern
  
      included do
        include Hap::Helpers::Heroku
      end
  
      protected
      
      def endpoints
        @endpoints ||= begin
          Array.new.tap{ |endpoints| 
            Dir.glob("endpoints/**/*").each_with_index do |file_path,index|
              if File.file? file_path
                
                path = file_path.gsub(/endpoints|\.rb/,"")[1..-1]
                source = to.production? ? "#{path}.rb" : file_path                
                name = path.parameterize.underscore

                servers = [{ 
                  address: address(path), port: port(name, index), 
                  options: 'inter 5000 fastinter 1000 fall 1 weight 50',
                  type: "web" 
                }]
                host = get_host(path)

                endpoints << {source: source, path: path, name: name, host: host, servers: servers}
              end
            end
          }
        end  
      end
      
      private
    
      def to
        @to ||= ActiveSupport::StringInquirer.new(env)
      end
      
      def target
        @target ||= to.production? ? "deploy" : "tmp"
      end

      def get_host path
        to.production? ? address(path) : "localhost"
      end

      def address path
        
        if to.production?
          
          data = "#{Hap.app_root}/#{target}/#{path}/heroku.json"
          create_app path unless File.exists?(data)
          
          app = Oj.load(File.read(data))
        
          app["domain_name"]["domain"]
          
        else
          "0.0.0.0"
          
        end      
                  
      end

      def port name, index
        to.production? ? 80 : next_port(name,index).to_s
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