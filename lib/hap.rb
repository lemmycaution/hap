require "hap/version"

module Hap
  class << self
    
    def env
      ENV['RACK_ENV'] ||= "development"
    end
    
    def config
      @config ||= YAML::load(File.read("config/hap.yml"))[Hap.env]
    end
    
  end
  
end
