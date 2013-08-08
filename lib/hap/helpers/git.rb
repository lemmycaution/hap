module Hap
  module Helpers
    module Git
  
      protected
      
      def bundle_and_git app, force = nil
        inside "#{Hap.app_root}/#{Hap::DEPLOYMENT_DIR}/#{app}" do
          Bundler.with_clean_env do
            run "bundle install"
          end
          run "git add ."
          run "git commit -am 'Auto deploy at #{Time.now}'"
          run "git push #{app} master #{force}"
        end
      end
      
      def git_init
        unless File.exists?(".git") 
          run "git init" 
          run "git add ."
          run "git commit -am 'initial commit'"
        end
      end
      
      def git_remote_add app
        run "git remote add production #{app["git_url"]}" unless has_remote_repository?
        run "heroku accounts:set #{heroku_account}" if has_accounts_plugin?                
      end
      
    end
  end
end