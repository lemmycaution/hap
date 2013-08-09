describe Hap::Generators::Endpoint do
  
  describe "when i run generator" do
    
    before do
      Hap::CLI.start ["new", dummy_path, "--force"]      
      Dir.chdir(dummy_path)
    end
    
    after do
      Dir.chdir("../..")      
      system "rm -rf #{dummy_path}"
    end
    
    it "it should create an endpoint with given name" do
      Hap::Generators::Endpoint.start ["my_end_point", "--force"]
      endpoint("my_end_point.rb").must_equal fixture("my_end_point.rb")
    end
    
    it "it should respects namespace" do
      Hap::Generators::Endpoint.start ["namespace/my_end_point", "--force"]
      endpoint("namespace/my_end_point.rb").must_equal fixture("namespace_my_end_point.rb")
    end    
    
  end
  
  
  
end