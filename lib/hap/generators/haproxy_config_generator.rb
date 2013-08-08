module Hap
  module Generators
    class HaproxyConfigGenerator < Thor::Group
  
      include Thor::Actions
      include Helpers::Endpoints     
      
      argument :env, default: Hap.env
      class_option :force, default: true
      
      def self.source_root
        Hap.app_root
      end

      def create_cfg_file
        template 'config/haproxy.cfg', path
      end
      
      def fix_port
        gsub_file path, "$PORT", "5000" unless to.production?
      end
      
      def convert_to_profile
        if to.production?
          copy_file path, path.gsub( File.basename(path), "haproxy.cfg" )
          prepend_file path do
            "#!/bin/bash\n"
            "cat > haproxy.cfg <<EOF\n"
          end
          append_file path do 
            "\nEOF"
          end
        end
      end
      
      protected
      
      def stats_admin
        ENV['STATS_ADMIN'] ||= "admin"
      end

      def stats_password
        ENV['STATS_PASSWORD'] ||= "password"
      end
      
      def path
        @path ||= "#{target}/#{Hap::FRONT_END}/#{filename}"
      end
      
      def filename
       to.production? ? ".profile" : "haproxy.cfg"
      end
  
    end
    
  end
end
