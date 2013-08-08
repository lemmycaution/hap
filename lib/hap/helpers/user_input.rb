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
      
      def set_env_var key,val
        file = "#{Hap.app_root}/.env"
        if File.exists?(file)
          if File.read(file).include?(key)
            gsub_file file, Regexp.new("#{key}=*.+"), "#{key}=#{val}"
          else
            append_file  file, "\n#{key}=#{val}"
          end
        else
          create_file file, "#{key}=#{val}"
        end
        ENV[key] = val    
      end
      
    end
  end
end