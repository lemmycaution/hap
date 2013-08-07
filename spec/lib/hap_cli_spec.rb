describe Hap do

  describe "when i run `hap` command" do
    it "should output help" do
      HapCLI.start.must_output "HELLO"
    end
  end

end