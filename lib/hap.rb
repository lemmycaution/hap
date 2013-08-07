require "hap/version"

module Hap
  class << self
    
    def env
      ENV['RACK_ENV'] ||= "development"
    end
    
  end
  
end
