describe Hap::Generators::Install do
  
  describe "when i run generator" do
    
    after do   
      system "rm -rf test/testapp"
    end
    
    it "it should creates a new Hap app and initialize git" do
      Hap::CLI.start ["new", "test/testapp" ,"--force"]
      Dir.glob("lib/hap/generators/templates/app").each do |source|
        target = source.gsub("lib/hap/generators/templates/app","test/testapp")
        File.exists?(target).must_equal true
        File.exists?("#{target}/.git").must_equal true 
      end
    end

    it "it should bundles after creating a new app" do
      Hap::CLI.start ["new", "test/testapp" ,"--bundle=true --force"]
      File.exists?("test/testapp/Gemfile.lock").must_equal true
    end    
    
    it "it should creates a new hap app with heroku app" do
      Hap::CLI.start ["new", "test/testapp" ,"--remote=true", "--force"]
      File.exists?("test/testapp/#{Hap::DEPLOYMENT_DIR}/#{Hap::FRONT_END}/#{Hap::APP_DATA_FILE}").must_equal true
    end
    
  end
  
end