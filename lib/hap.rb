require 'pathname'
require "active_support/inflector"
require "active_support/string_inquirer"
require "active_support/concern"

require "hap/version"

module ::Kernel
  def called_from(level=1)
    arrs = caller((level||1)+1)  or return
    arrs[0] =~ /:(\d+)(?::in `(.*)')?/ ? [$`, $1.to_i, $2] : nil
  end
end

module Hap
  
  FRONT_END = "frontend"
  BACK_END  = "backend"
  
  class << self
    
    def env
      @env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] ||= "development")
    end
    
    def env=(environment)
      @env = ActiveSupport::StringInquirer.new(environment)
    end
    
    def app_root
      @app_root ||= find_root_with_flag('server.rb', Dir.pwd)
    end
    
    # i steal this from rails
    def find_root_with_flag(flag, default=nil)
      root_path = self.class.called_from[0]

      while root_path && File.directory?(root_path) && !File.exist?("#{root_path}/#{flag}")
        parent = File.dirname(root_path)
        root_path = parent != root_path && parent
      end

      root = File.exist?("#{root_path}/#{flag}") ? root_path : default
      raise "Could not find root path for #{self}" unless root

      RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ?
        Pathname.new(root).expand_path : Pathname.new(root).realpath
    end
    
  end
  
end

require "hap/helpers/heroku"
require "hap/helpers/user_input"
require "hap/helpers/deploy"
require 'hap/generators/endpoint_generator'
require 'hap/generators/haproxy_config_generator'
require 'hap/generators/install_generator'
require 'hap/generators/procfile_generator'
require 'hap/cli'