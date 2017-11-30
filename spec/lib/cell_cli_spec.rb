require "spec_helper"
require "cli"

RSpec.describe CellCLI do

  subject(:cell_cli) { described_class.new }

  let(:cell) { FactoryBot.create :cell }

  before { cell }

  describe "#ls" do
    it "contains the cell uuid in the output" do
      expect { cell_cli.ls }.to output(/#{cell.uuid}/).to_stdout
    end
  end

  describe "#accept" do
    before { with_suppressed_output }

    let(:acceptance_params) do
      {
        path:    "/admin-api/v1/cells/#{cell.uuid}/accept",
        method:  :post,
        payload: {
          cell: {
            block_devices: []
          }
        }
      }
    end

    context "with a successful request" do
      before do
        allow(BrainAdminApi).to receive(:request).once.with(acceptance_params)
                                                 .and_return OpenStruct.new(code: 200)
      end

      it "accepts a cell" do
        cell_cli.accept cell.uuid
        expect(BrainAdminApi).to have_received(:request).once.with acceptance_params
      end

      it "does not return with an error status" do
        expect { cell_cli.accept cell.uuid }.not_to raise_exception
      end
    end

    context "with an unsuccessful request" do
      before do
        allow(BrainAdminApi).to receive(:request).once.with(acceptance_params)
                                                 .and_return OpenStruct.new(code: 200)
      end

      it "returns with an error status" do
        begin
          cell_cli.accept cell.uuid
        rescue SystemExit => e
          expect(e.status).to eq 1
        end
      end
    end
  end

end
