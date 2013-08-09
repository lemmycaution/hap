module Hap
  module Helpers
    module Git
  
      protected
      
      def bundle_and_git app, force = nil
        inside "#{Hap.app_root}/#{Hap::DEPLOYMENT_DIR}/#{app}" do
          Bundler.with_clean_env do
            run "bundle install", capture: true
          end
          run "git add .", capture: true
          run "git commit -am 'Auto deploy at #{Time.now}'", capture: true
          run "git push #{app} master #{force}", capture: true
        end
      end
      
      def git_init
        unless File.exists?(".git") 
          run "git init", capture: true
          run "git add .", capture: true
          run "git commit -am 'initial commit'", capture: true
        end
      end
      
      def git_remote_add app
        run "git remote add production #{app.data["git_url"]}" unless has_remote_repository?
        run "heroku accounts:set #{heroku_account}" if has_accounts_plugin?                
      end
      
    end
  end
end