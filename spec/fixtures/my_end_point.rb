require 'goliath'

class MyEndPoint < Goliath::API
  def response(env)
    [200,{},"OK"]
  end
end
