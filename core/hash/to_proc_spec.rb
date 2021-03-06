require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.3" do
  describe "Hash#to_proc" do
    before :each do
      @key = Object.new
      @value = Object.new
      @hash = new_hash @key => @value
      @default = Object.new
      @unstored = Object.new
    end

    it "returns an instance of Proc" do
      @hash.to_proc.should.be_an_instance_of Proc
    end

    describe "the returned proc" do
      before :each do
        @proc = @hash.to_proc
      end

      context "with a stored key" do
        it "returns the pared value" do
          @proc.call(@key).should equal(@value)
        end
      end

      context "with a no stored key" do
        it "returns nil" do
          @proc.call(@unstored).should be_nil
        end

        context "when the hash has a default value" do
          before :each do
            @hash.default = @default
          end

          it "returns the default value" do
            @proc.call(@unstored).should equal(@default)
          end
        end

        context "when the hash has a default proc" do
          it "returns an evaluated value from the default proc" do
            @hash.default_proc = -> hash, called_with {  [hash.keys, called_with] }
            @proc.call(@unstored).should == [[@key], @unstored]
          end
        end
      end
    end
  end
end
