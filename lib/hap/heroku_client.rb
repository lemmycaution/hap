require 'heroku-api'
require 'active_support'

module Hap
  module HerokuClient
    
    extend ActiveSupport::Concern
    
    protected
    
    def heroku api_key
      @heroku ||=  Heroku::API.new(api_key: api_key)
    end
    
  end
end