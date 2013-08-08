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
    
    it "it should creates procfile for haproxy" do
      Hap::Generators::ProcfileGenerator.start ["frontend"]
      File.read("tmp/#{Hap::FRONT_END}/Procfile").must_equal File.read("../../spec/fixtures/Procfile.frontend")
    end
    
    it "it should creates procfile for backends as well" do
      Hap::Generators::EndpointGenerator.start ["my_end_point", "--force"]
      Hap::Generators::ProcfileGenerator.start ["my_end_point"]
      File.read("tmp/my_end_point/Procfile").must_equal File.read("../../spec/fixtures/Procfile.backend")
    end    
    
    it "it should creates procfile for haproxy PROD" do
      Hap::Generators::ProcfileGenerator.start ["frontend", "production"]
      File.read("deploy/#{Hap::FRONT_END}/Procfile").must_equal File.read("../../spec/fixtures/Procfile.frontend.pro")
    end
    
    it "it should creates procfile for backends as well PROD" do
      Hap::Generators::EndpointGenerator.start ["my_end_point", "--force"]
      Hap::Generators::ProcfileGenerator.start ["my_end_point", "production"]
      File.read("deploy/my_end_point/Procfile").must_equal File.read("../../spec/fixtures/Procfile.backend.pro")
    end  
    
  end
  
  
  
end