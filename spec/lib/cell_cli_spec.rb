require "spec_helper"
require "cli"

RSpec.describe CellCLI do

  subject(:cell_cli) { described_class.new }

  let(:cell) { FactoryGirl.create :cell }
  let(:discovered_cell) { FactoryGirl.create :cell, status: :discovered }

  before { cell }

  describe "#ls" do
    it "contains the cell uuid in the output" do
      expect { cell_cli.ls }.to output(/#{cell.uuid}/).to_stdout
    end
  end

  describe "#accept" do
    context "with a discovered cell" do
      before { with_suppressed_output }

      it "accepts a cell" do
        expect { cell_cli.accept discovered_cell.uuid }.to change { discovered_cell.reload.status }
          .from("discovered").to("accepted")
      end
    end

    context "with an already accepted cell" do
      before { with_suppressed_output }

      # rubocop:disable RSpec/ExampleLength
      # rubocop:disable Lint/HandleExceptions
      it "does not accept the cell" do
        expect do
          begin
            cell_cli.accept cell.uuid
          rescue SystemExit
          end
        end.not_to(change { cell.reload.status })
      end
      # rubocop:enable Lint/HandleExceptions
      # rubocop:enable RSpec/ExampleLength

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
