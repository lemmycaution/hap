module Hap
  module Helpers
    module Git
      
      extend ActiveSupport::Concern
  
      protected
      
      def bundle_and_git app, force = nil
        inside "deploy/#{app}", verbose: true do
          Bundler.with_clean_env do
            run "bundle install", verbose: true
          end
          run "git add .", verbose: true
          run "git commit -am 'Auto deploy at #{Time.now}'", verbose: true
          run "git push #{app} master #{force}", verbose: true
        end
      end
         
    end
  end
end