module Hap
  module Constants
    
    DEPLOYMENT_DIR  = "tmp/deploy"
    RUNTIME_DIR     = "tmp/server"    
    ENDPOINTS_DIR   = "app/endpoints"
    
    FRONT_END     = "frontend"
    BACK_END      = "backend"
    BUILDPACK_URL = 'https://github.com/kiafaldorius/haproxy-buildpack'
    
    HAPROXY_BACKEND_SERVER_OPTIONS = 'inter 5000 fastinter 1000 fall 1 weight 50'
    DEFAULT_PROCESS_TYPE = "web"
    
    DEVELOPMENT_HOST = "localhost"
    DEFAULT_TCP_PORT = 80
    
    DEPLOYED_FRONTEND = "#{DEPLOYMENT_DIR}/#{FRONT_END}"
    APP_DATA_FILE = "heroku.json"
  end
end