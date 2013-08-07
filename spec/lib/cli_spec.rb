require "hap/cli"

describe Hap::CLI do

  describe "when i run `hap` command" do
    it "should output help" do
      -> { Hap::CLI.start }.must_output "HAP!"
    end
  end

end