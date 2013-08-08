module Hap
  module Helpers
    module UserInput
      
      extend ActiveSupport::Concern
  
      private
      
      def ask_user(option)
        value = ask("Please enter your #{option}:")
        raise Thor::Error, "You must enter a value for that field." if value.empty?
        value
      end
      
    end
  end
end