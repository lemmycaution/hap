require "hap/version"

module Hap
  class << self
    def env
      ENV['RACK_ENV'] ||= "development"
    end
    def root
      File.expand(__FILE__, "../..")
    end
  end
end
