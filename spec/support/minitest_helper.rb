require 'minitest/pride'
require 'minitest/autorun'

class MiniTest::Spec
  
  def procfile app, production = nil
    File.read("#{ENV['GEM_ROOT']}/spec/fixtures/#{app}/Procfile#{production}")
  end
  def dummy_path
    "test/tmp/testapp"
  end
  def fixture filename
    File.read("#{ENV['GEM_ROOT']}/spec/fixtures/#{filename}")
  end
  def endpoint filename
    File.read("#{Hap.app_root}/#{Hap::ENDPOINTS_DIR}/#{filename}")
  end
end