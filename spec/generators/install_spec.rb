describe Hap::Generators::Install do
  
  describe "when i run generator" do
    
    after do   
      system "rm -rf #{dummy_path}"
    end
    
    it "it should creates a new Hap app and initialize git" do
      Hap::CLI.start ["new", dummy_path ,"--force"]
      Dir.glob("lib/hap/generators/templates/app").each do |source|
        target = source.gsub("lib/hap/generators/templates/app",dummy_path)
        File.exists?(target).must_equal true
        File.exists?("#{target}/.git").must_equal true 
      end
    end

    it "it should bundles after creating a new app" do
      Hap::CLI.start ["new", dummy_path ,"--bundle=true --force"]
      File.exists?("#{dummy_path}/Gemfile.lock").must_equal true
    end    
    
    it "it should creates a new hap app with heroku app" do
      Hap::CLI.start ["new", dummy_path ,"--remote=true", "--force"]
      File.exists?("#{dummy_path}/#{Hap::DEPLOYMENT_DIR}/#{Hap::FRONT_END}/#{Hap::APP_DATA_FILE}").must_equal true
    end
    
  end
  
end