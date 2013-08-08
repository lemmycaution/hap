require 'hap/cli'

describe Hap::Generators::InstallGenerator do
  
  describe "when i run generator" do
    
    after do   
      system "rm -rf test/testapp"
    end
    
    it "it should creates a new hap app" do
      Hap::CLI.start ["new", "test/testapp" ,"--bundle=true -- force"]
      Dir.glob("lib/hap/generators/templates/app").each do |source|
        target = source.gsub("lib/hap/generators/templates/app","test/testapp")
        File.exists?(target).must_equal true
      end
      File.exists?("test/testapp/Gemfile.lock").must_equal true
    end
    
  end
  
end