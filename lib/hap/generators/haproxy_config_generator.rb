require 'thor/group'
require 'thor/actions'
require 'hap/generators/helpers/config_helper'

module Hap
  module Generators
    class HaproxyConfigGenerator < Thor::Group
  
      include Thor::Actions
      include Generators::Helpers::ConfigHelper     
      
      class_option :force, default: true
      
      def self.source_root
        Dir.pwd
      end

      def create_cfg_file
        template 'config/haproxy.cfg', "tmp/frontend/haproxy.cfg"
      end
  
    end
    
  end
end
