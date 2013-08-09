describe Hap::Generators::Endpoint do
  
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
      Hap::Generators::Endpoint.start ["my_end_point", "--force"]
      File.read("#{Hap.app_root}/#{Hap::ENDPOINTS_DIR}/my_end_point.rb").must_equal File.read("../../spec/fixtures/my_end_point.rb")
    end
    
    it "it should respects namespace" do
      Hap::Generators::Endpoint.start ["namespace/my_end_point", "--force"]
      File.read("#{Hap.app_root}/#{Hap::ENDPOINTS_DIR}/namespace/my_end_point.rb").must_equal File.read("../../spec/fixtures/namespace_my_end_point.rb")
    end    
    
  end
  
  
  
end