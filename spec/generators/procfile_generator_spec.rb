require 'hap/cli'

describe Hap::Generators::ProcfileGenerator do
  
  describe "when i run generator" do
    
    before do
      Hap::CLI.start ["new", "test/testapp", "--force"]      
      Dir.chdir("test/testapp")
    end
    
    after do
      Dir.chdir("../..")      
      system "rm -rf test/testapp"
    end
    
    it "it should creates procfile" do
      Hap::Generators::ProcfileGenerator.start
      File.read("tmp/frontend/Procfile").must_equal File.read("../../spec/fixtures/Procfile")
    end
    
  end
  
  
  
end