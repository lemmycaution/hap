require "hap/version"

module Hap
  class << self
    
    def root
      Dir.pwd
    end
    
    def env
      ENV['RACK_ENV'] ||= "development"
    end
    
    def config
      @config ||= YAML::load(File.read("config/hap.yml"))[env]
    end
    
  end
  
end
