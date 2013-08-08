require 'hap/cli'

describe Hap::Generators::EndpointGenerator do
  
  describe "when i run generator" do
    
    before do
      Hap::CLI.start ["new", "test/testapp", "--force"]      
      Dir.chdir("test/testapp")
    end
    
    after do
      Dir.chdir("../..")      
      system "rm -rf test/testapp"
    end
    
    it "it should create an endpoint with given name" do
      Hap::Generators::EndpointGenerator.start ["my_end_point", "--force"]
      File.read("endpoints/my_end_point.rb").must_equal File.read("../../spec/fixtures/my_end_point.rb")
    end
    
    it "it should respects namespace" do
      Hap::Generators::EndpointGenerator.start ["namespace/my_end_point", "--force"]
      File.read("endpoints/namespace/my_end_point.rb").must_equal File.read("../../spec/fixtures/namespace_my_end_point.rb")
    end    
    
  end
  
  
  
end