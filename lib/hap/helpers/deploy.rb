module Hap
  module Helpers    
    module Deploy
      extend ActiveSupport::Concern
  
      protected
      
      def endpoints
        @endpoints ||= begin
          Array.new.tap{ |endpoints| 
            Dir.glob("endpoints/**/*").each_with_index do |path,index|
              if File.file? path
                source = path
                path = path.gsub(/endpoints|\.rb/,"")
                name = path.parameterize.underscore
                servers = [
                  { address: address(path), port: port(name, index), 
                    options: 'inter 5000 fastinter 1000 fall 1 weight 50' }
                ]
                endpoints << {source: source, path: path, name: name, host: host(path), servers: servers}
              end
            end
          }
        end  
      end
      
      private
      
      def to
        @to ||= ActiveSupport::StringInquirer.new(target)
      end
        
      def target
        @target ||= to.production ? "deploy" : "tmp"
      end

      def host path
        to.production? ? address(path) : "localhost"
      end

      def address path
        if to.production?
          data = "#{Hap.app_root}/#{target}/#{path}/heroku.json"
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