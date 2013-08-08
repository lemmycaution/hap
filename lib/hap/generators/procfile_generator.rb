module Hap
  module Generators
    class ProcfileGenerator < Thor::Group
  
      include Thor::Actions
      include Helpers::Deploy
      
      argument :app, default: Hap::FRONT_END
      argument :target, default: Hap.env
      class_option :force, default: true
      
      def self.source_root
        Hap.app_root
      end

      def create_procfile
        template "config/Procfile.#{type}", "#{target}/#{app}/Procfile"
      end
      
      private
      
      def type
        app != Hap::FRONT_END ? app : Hap::FRONT_END
      end
      
      def haproxy
        to.production? ? "./haproxy -f haproxy.cfg" : "haproxy -f tmp/#{Hap::FRONT_END}/haproxy.cfg -d -V"
      end

      def endpoints
        return [] if to.production? && app == Hap::FRONT_END
        super
      end
  
    end
    
  end
end