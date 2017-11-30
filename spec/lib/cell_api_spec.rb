require "spec_helper"
require "brain"

RSpec.describe CellApi do
  let(:cell)     { FactoryBot.create :cell }
  let(:cell_api) { described_class.new cell: cell }

  describe "#request" do
    let(:path)    { "/some/path" }
    let(:payload) { { some: "payload" } }

    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(
        OpenStruct.new(body: '{ "some": "json" }')
      )
      # rubocop:enable RSpec/AnyInstance
    end

    context "head request" do
      subject { cell_api.request(path: path, method: :head).second }

      it { is_expected.to eq some: "json" }
    end

    context "get request" do
      subject { cell_api.request(path: path, method: :get).second }

      it { is_expected.to eq some: "json" }
    end

    context "post request" do
      subject { cell_api.request(path: path, method: :post, payload: payload).second }

      it { is_expected.to eq some: "json" }
    end

    context "put request" do
      subject { cell_api.request(path: path, method: :put, payload: payload).second }

      it { is_expected.to eq some: "json" }
    end

    context "patch request" do
      subject { cell_api.request(path: path, method: :patch, payload: payload).second }

      it { is_expected.to eq some: "json" }
    end

    context "delete request" do
      subject { cell_api.request(path: path, method: :delete).second }

      it { is_expected.to eq some: "json" }
    end

    context "with a json parsing error on the response" do
      before do
        allow(JSON).to receive(:parse).and_raise JSON::ParserError
      end

      subject { cell_api.request(path: path, method: :get).second }

      it { is_expected.to be_nil }
    end

    context "when a block has been passed" do
      it "yields the expected times" do
        expect { |b| cell_api.request path: path, method: :get, &b }.to(
          yield_control.exactly(1).times
        )
      end

      it "yields with the expected information" do
        expect do |b|
          cell_api.request path: path, method: :get, &b
        end.to yield_with_args(anything, some: "json")
      end
    end
  end

  describe ".accept_block_devices" do
    let(:request_params) do
      {
        path:    "/admin-api/v1/block-devices",
        method:  :patch,
        payload: {
          block_devices: Hash[
            cell.block_devices.map do |block_device|
              [block_device.device, status: :accepted]
            end
          ]
        }
      }
    end

    it "makes a request to the cell" do
      allow(cell_api).to receive(:request).with request_params
      cell_api.accept_block_devices block_devices: cell.block_devices.pluck(:device)
      expect(cell_api).to have_received(:request).once.with request_params
    end
  end

  describe ".sync_object" do
    let(:sync_token) { FactoryBot.create :sync_token }
    let(:request_params) do
      {
        path:    "/admin-api/v1/objects",
        method:  :post,
        payload: {
          sync_token: sync_token.token
        }
      }
    end

    it "makes a request to the target cell" do
      allow(sync_token.target_cell.remote).to receive(:request).with(request_params)
      sync_token.sync_object
      expect(sync_token.target_cell.remote).to have_received(:request).with(request_params)
    end
  end
end
