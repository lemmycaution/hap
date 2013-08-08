require 'hap/cli'

describe Hap::Generators::HaproxyConfigGenerator do
  
  describe "when i run generator" do
    
    before do
      Hap::CLI.start ["new", "test/testapp", "--force"]      
      Dir.chdir("test/testapp")
    end
    
    after do
      Dir.chdir("../..")      
      system "rm -rf test/testapp"
    end
    
    it "it should templates haproxy config based on environment" do
      Hap::Generators::HaproxyConfigGenerator.start
      File.read("tmp/frontend/haproxy.cfg").must_equal File.read("../../spec/fixtures/haproxy.cfg")
    end
    
  end
  
  
  
end