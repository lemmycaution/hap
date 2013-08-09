require 'oj'
require 'heroku-api'

module Hap
  class App
    
    @data = {}
    
    attr_accessor :name, :file, :data
    
    def initialize name
      @name = name
      @file = "#{Hap.app_root}/#{Hap::DEPLOYMENT_DIR}/#{name}/#{Hap::APP_DATA_FILE}"
      @data = Oj.load(File.read(@file)) if exists?
    end
    
    def exists?
      @exists ||= File.exists?(@file)
    end
    
    def frontend?
      @name == Hap::FRONT_END
    end
    
    def data
      @data["domain_name"] = {"domain" => "TEST"} if Hap.env.test?
      @data
    end
    
    def create!(api_key = nil)
      return self if exists?
      self.api_key = api_key
      @data = heroku.post_app(name: nil).body 
      add_buildpack if frontend?
      self
    end
    
    def destroy!(api_key = nil)
      return unless exists?
      self.api_key = api_key
      heroku.delete_app @data["name"] rescue nil
    end
    
    def api_key= api_key
      @api_key = api_key unless api_key.nil?
    end
    
    def missing_method(method,*args,&block)
      return @data.send(method, *args, &block) if @data.respond_to?(method)
      super(method,*args,&block)    
    end
    
    private
    
    def heroku 
      @heroku ||= ::Heroku::API.new(api_key: @api_key, :mock => Hap.env.test?)
    end
    
    def add_buildpack
      heroku.put_config_vars @data["name"], {
        "BUILDPACK_URL" => Hap::BUILDPACK_URL
      }
    end
    
  end
end