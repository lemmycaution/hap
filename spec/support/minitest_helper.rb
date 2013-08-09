require 'minitest/pride'
require 'minitest/autorun'

class MiniTest::Spec
  
  def procfile app, production = nil
    File.read("../../spec/fixtures/#{app}/Procfile#{production}")
  end
  
end