module Hap
  module Generators
    class Procfile < Thor::Group
  
      include Hap::Helpers
      
      argument :app, default: Hap::FRONT_END
      argument :env, default: Hap.env
      class_option :force, default: true
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def create_procfile
        template "templates/config/#{type}/Procfile.erb", 
        "#{Hap.app_root}/#{target}/#{app}/Procfile"
      end
      
      private
      
      def type
        app == Hap::FRONT_END ? Hap::FRONT_END : Hap::BACK_END
      end
      
      def haproxy
        to.production? ? "./haproxy -f haproxy.cfg" : 
        "haproxy -f #{Hap::RUNTIME_DIR}/#{Hap::FRONT_END}/haproxy.cfg -d -V"
      end
      
      def backend
        path = app.is_a?(String) ? app : app.name
        endpoints(true).select{|e| e[:path] == path }[0]
      end
  
    end
    
  end
end