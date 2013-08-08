module Hap
  module Generators
    class ProcfileGenerator < Thor::Group
  
      include Thor::Actions
      include Helpers::Deploy
      
      argument :endpoint, default: Hap::FRONT_END
      argument :env, default: Hap.env
      class_option :force, default: true
      
      def self.source_root
        Hap.app_root
      end

      def create_procfile
        template "config/Procfile.#{type}", "#{target}/#{endpoint}/Procfile"
      end
      
      private
      
      def type
        endpoint == Hap::FRONT_END ? Hap::FRONT_END : Hap::BACK_END
      end
      
      def haproxy
        to.production? ? "./haproxy -f haproxy.cfg" : "haproxy -f tmp/#{Hap::FRONT_END}/haproxy.cfg -d -V"
      end

      def endpoints
        return [] if to.production? && endpoint == Hap::FRONT_END
        super
      end
      
      def backend
        endpoints.select{|e| e[:path] == "/#{endpoint}"}[0]
      end
  
    end
    
  end
end