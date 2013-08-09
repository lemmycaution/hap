module Hap
  module Generators
    class Haproxy < Thor::Group
  
      include Hap::Helpers     
      
      argument :env, default: Hap.env
      class_option :force, default: true
      
      def self.source_root
        File.dirname(__FILE__)
      end

      def create_cfg_file
        template "templates/config/#{Hap::FRONT_END}/haproxy.cfg.erb", target_file
      end
      
      def fix_port
        gsub_file target_file, "$PORT", "5000" unless to.production?
      end
      
      def convert_to_profile
        if to.production?
          copy_file target_file, target_file.gsub( File.basename(target_file), "haproxy.cfg" )
          prepend_file target_file do
            "#!/bin/bash\n"
            "cat > haproxy.cfg <<EOF\n"
          end
          append_file target_file do 
            "\nEOF"
          end
        end
      end
      
      protected
      
      def stats_admin
        @stats_admin ||= ENV['STATS_ADMIN'] ||= "admin"
      end

      def stats_password
        @stats_password ||= ENV['STATS_PASSWORD'] ||= "password"
      end
      
      def target_file
        @target_file ||= "#{Hap.app_root}/#{target}/#{Hap::FRONT_END}/#{filename}"
      end
      
      def filename
       @filename ||= to.production? ? ".profile" : "haproxy.cfg"
      end
  
    end
    
  end
end
