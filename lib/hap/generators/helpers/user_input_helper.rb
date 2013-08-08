require 'active_support/concern'

module Hap
  module Generators
    module Helpers
      module UserInputHelper
        extend ActiveSupport::Concern
  
        private
      
        def get_option(option)
          value = ask("Please enter your #{option}:")
          raise Thor::Error, "You must enter a value for that field." if value.empty?
          value
        end
      
      end
    end
  end
end