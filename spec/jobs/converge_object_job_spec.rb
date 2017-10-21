require "spec_helper"

RSpec.describe ConvergeObjectJob do

  let(:object) { FactoryGirl.create :full_object }

  describe "#perform" do
    it "calls to Brain.converge_object" do
      allow(Brain).to receive(:converge_object).with object: object
      described_class.perform_now object: object
      expect(Brain).to have_received(:converge_object).with(object: object).once
    end
  end

end
