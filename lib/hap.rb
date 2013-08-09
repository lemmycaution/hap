require "kernel"
require 'pathname'
require "active_support/inflector"
require "active_support/string_inquirer"
require "active_support/concern"
require "active_support/dependencies/autoload"

module Hap
  
  extend ActiveSupport::Autoload
  
  eager_autoload do
    autoload :App
    autoload :CLI    
    autoload :Constants  
    autoload :Generators      
    autoload :Helpers              
    autoload :Version    
  end
  
  include Constants
  
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
    
    def app_root= app_root
      @app_root = app_root
    end    
    
    def in_app_dir?
      File.exists?("#{Hap.app_root}/server.rb")
    end
    
    private
    
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