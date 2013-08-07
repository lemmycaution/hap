require 'active_support/inflector'
require 'thor/group'
require 'yaml'

module Hap
  module Generators
    class HaproxyConfigGenerator < Thor::Group
  
      include Thor::Actions
  
      def self.source_root
        File.dirname(__FILE__)
      end

      def create_cfg_file
        template('config/haproxy.erb', "tmp/frontend/haproxy.cfg")
      end
  
      private
  
      def config
        YAML::load(File.read("config/hap.yml"))[Hap.env]
      end
  
      def app_name
        @app_name ||= config["name"].underscore
      end

      def stats_admin
        ENV['STATS_ADMIN'] ||= "admin"
      end

      def stats_password
        ENV['STATS_PASSWORD'] ||= "password"
      end
  
      def bind
        config["frontend"]["bind"]
      end
  
      def host name
        config["backend"]["host"].
        gsub("%{domain}",config["backend"]["domain"]).
        gsub("%{address}",address(name))
      end
  
      def address name
        config["backend"]["address"].
        gsub("%{app_name}",app_name).
        gsub("%{name}",name).
        gsub("%{domain}",config["backend"]["domain"])
      end
  
      def port name, index
        config["backend"]["port"].to_s.
        gsub("%{port}",next_port(name,index).to_s)
      end
  
      def next_port name, index
        if ports[name]
          ports[name] += 1
        else
          ports[name] = [index,1].max * 1000
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
                path = path.gsub(/endpoints|\.rb/,"")
                name = path.parameterize.underscore
                servers = [
                  { address: address(name), port: port(name, index), options: 'inter 5000 fastinter 1000 fall 1 weight 50' }
                ]
                endpoints << {path: path, name: name, host: host(name), servers: servers}
              end
            end
          }
        end  
      end
  
    end
    
  end
end