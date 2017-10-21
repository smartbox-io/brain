require "spec_helper"

RSpec.describe Cell do
  let(:cell) { FactoryBot.create :cell }

  it { is_expected.to have_many(:volumes).class_name("CellVolume").dependent(:destroy) }
  it { is_expected.to have_many(:object_backups).through(:volumes) }
  it { is_expected.to have_many(:object_replicas).through(:volumes) }
  it { is_expected.to have_many(:sync_source_tokens).through(:volumes) }
  it { is_expected.to have_many(:sync_target_tokens).through(:volumes) }
  it { is_expected.to define_enum_for(:status).with(%i[discovered accepted healthy unhealthy]) }

  describe "#accept" do
    subject { cell.accept }

    context "current status is discovered" do
      let(:cell) { FactoryBot.create :cell, status: described_class.statuses[:discovered] }

      it { is_expected.to be true }

      it "sets the cell in accepted status" do
        expect { cell.accept }.to change { cell.reload.status }.from("discovered").to("accepted")
      end
    end

    (described_class.statuses.keys - ["discovered"]).each do |status|
      context "current status is #{status}" do
        let(:cell) { FactoryBot.create :cell, status: status }

        it { is_expected.to be false }

        it "does not change cell status" do
          expect { cell.accept }.not_to(change { cell.reload.status })
        end
      end
    end
  end

  describe "#request" do
    let(:path) { "/some/path" }
    let(:payload) { { some: "payload" } }

    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(
        OpenStruct.new(body: '{ "some": "json" }')
      )
      # rubocop:enable RSpec/AnyInstance
    end

    context "head request" do
      subject { cell.request(path: path, method: :head).second }

      it { is_expected.to eq some: "json" }
    end

    context "get request" do
      subject { cell.request(path: path, method: :get).second }

      it { is_expected.to eq some: "json" }
    end

    context "post request" do
      subject { cell.request(path: path, method: :post, payload: payload).second }

      it { is_expected.to eq some: "json" }
    end

    context "put request" do
      subject { cell.request(path: path, method: :put, payload: payload).second }

      it { is_expected.to eq some: "json" }
    end

    context "patch request" do
      subject { cell.request(path: path, method: :patch, payload: payload).second }

      it { is_expected.to eq some: "json" }
    end

    context "delete request" do
      subject { cell.request(path: path, method: :delete).second }

      it { is_expected.to eq some: "json" }
    end

    context "with a json parsing error on the response" do
      before do
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError)
      end

      subject { cell.request(path: path, method: :get).second }

      it { is_expected.to be_nil }
    end

    context "when a block has been passed" do
      it "yields the expected times" do
        expect { |b| cell.request path: path, method: :get, &b }.to yield_control.exactly(1).times
      end

      it "yields with the expected information" do
        expect do |b|
          cell.request path: path, method: :get, &b
        end.to yield_with_args(anything, some: "json")
      end
    end
  end
end
