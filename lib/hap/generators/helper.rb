require 'yaml'
require 'active_support/inflector'
require 'active_support/concern'

module Hap
  module Generators
    module Helper
      extend ActiveSupport::Concern
  
      private

      def app_name
        @app_name ||= Hap.config["name"].underscore
      end

      def stats_admin
        ENV['STATS_ADMIN'] ||= "admin"
      end

      def stats_password
        ENV['STATS_PASSWORD'] ||= "password"
      end

      def bind
        Hap.config["frontend"]["bind"]
      end

      def host name
        Hap.config["backend"]["host"].
        gsub("%{domain}",Hap.config["backend"]["domain"]).
        gsub("%{address}",address(name))
      end

      def address name
        Hap.config["backend"]["address"].
        gsub("%{app_name}",app_name).
        gsub("%{name}",name).
        gsub("%{domain}",Hap.config["backend"]["domain"])
      end

      def port name, index
        Hap.config["backend"]["port"].to_s.
        gsub("%{port}",next_port(name,index).to_s)
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

      def endpoints
        @endpoints ||= begin
          Array.new.tap{ |endpoints| 
            Dir.glob("endpoints/**/*").each_with_index do |path,index|
              if File.file? path
                source = path
                path = path.gsub(/endpoints|\.rb/,"")
                name = path.parameterize.underscore
                servers = [
                  { address: address(name), port: port(name, index), options: 'inter 5000 fastinter 1000 fall 1 weight 50' }
                ]
                endpoints << {source: source, path: path, name: name, host: host(name), servers: servers}
              end
            end
          }
        end  
      end
  
    end
  end
end