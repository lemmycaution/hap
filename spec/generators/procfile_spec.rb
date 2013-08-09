describe Hap::Generators::Procfile do
  
  describe "when i run generator" do
    
    before do
      Hap::CLI.start ["new", "test/testapp", "--force"]      
      Dir.chdir("test/testapp")
    end
    
    after do
      Dir.chdir("../..")      
      system "rm -rf test/testapp"
    end
    
    it "it should creates procfile for Frontend [haproxy]" do
      Hap::Generators::Procfile.start [Hap::FRONT_END]
      File.read("#{Hap::RUNTIME_DIR}/#{Hap::FRONT_END}/Procfile").must_equal procfile(Hap::FRONT_END)
    end
    
    it "it should creates procfile for Backend" do
      Hap::Generators::Endpoint.start ["my_end_point", "--force"]
      Hap::Generators::Procfile.start ["my_end_point"]
      File.read("#{Hap::RUNTIME_DIR}/my_end_point/Procfile").must_equal procfile(Hap::BACK_END)
    end    
        
    it "it should creates procfile for Frontend [haproxy] for Deployment" do
      Hap::Generators::Procfile.start ["frontend", "production"]
      File.read("#{Hap::DEPLOYMENT_DIR}/#{Hap::FRONT_END}/Procfile").must_equal procfile(Hap::FRONT_END, ".production")
    end
    
    it "it should creates procfile for Backend for Deployment" do
      Hap::Generators::Endpoint.start ["my_end_point", "--force"]
      Hap::Generators::Procfile.start ["my_end_point", "production"]
      File.read("#{Hap::DEPLOYMENT_DIR}/my_end_point/Procfile").must_equal procfile(Hap::BACK_END, ".production")
    end  
    
  end
  
  
  
end