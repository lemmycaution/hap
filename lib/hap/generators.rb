module Hap
  module Generators
    
    extend ActiveSupport::Autoload
  
    eager_autoload do
      autoload :Endpoint    
      autoload :Gemfile      
      autoload :Haproxy
      autoload :Install                    
      autoload :Procfile      
    end

  end
end