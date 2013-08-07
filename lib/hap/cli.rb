require "thor"

module Hap
  class CLI < Thor
    desc "help", "Prints help"
    def help
      print "HAP!"
    end
  end
end
