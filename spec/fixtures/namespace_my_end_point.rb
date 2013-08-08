require 'goliath'

module Namespace

class MyEndPoint < Goliath::API
  def response(env)
    [200,{},"OK"]
  end
end

end
