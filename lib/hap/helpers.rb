module Hap
  module Helpers
    
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload
  
    eager_autoload do
      autoload :Endpoint      
      autoload :Git      
      autoload :Heroku
      autoload :UserInput                    
    end
    
    included do
      include Heroku
      include UserInput
      include Git
      include Endpoint                
      include Thor::Actions
    end
    
  end
end