describe Hap::Generators::Haproxy do
  
  describe "when i run generator" do
    
    before do
      Hap::CLI.start ["new", dummy_path, "--force"]      
      Dir.chdir(dummy_path)
    end
    
    after do
      Dir.chdir("../..")      
      system "rm -rf #{dummy_path}"
    end
    
    it "it should templates haproxy config based on environment" do
      Hap::Generators::Haproxy.start ["development"]
      File.read("#{Hap::RUNTIME_DIR}/#{Hap::FRONT_END}/haproxy.cfg").must_equal fixture("#{Hap::FRONT_END}/haproxy.cfg")
    end
    
    it "it should templates haproxy config based on environment [DEV]" do
      Hap::Generators::Haproxy.start ["production"]
      File.read("#{Hap::DEPLOYMENT_DIR}/#{Hap::FRONT_END}/haproxy.cfg").must_equal fixture("#{Hap::FRONT_END}/haproxy.cfg.production")
    end
    
  end
  
  
  
end