require "spec_helper"
require "brain_admin_api"

RSpec.describe BrainAdminApi do

  let(:username) { "test@example.com" }
  let(:password) { "test" }
  let(:path) { "/some/path" }
  let(:payload) { { some: "payload" } }

  describe ".request" do
    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(
        OpenStruct.new(body: '{ "some": "json" }')
      )
      # rubocop:enable RSpec/AnyInstance
    end

    context "head request" do
      subject do
        described_class.request(
          username: username, password: password, path: path, method: :head
        ).second
      end

      it { is_expected.to eq some: "json" }
    end

    context "get request" do
      subject do
        described_class.request(
          username: username, password: password, path: path, method: :get
        ).second
      end

      it { is_expected.to eq some: "json" }
    end

    context "post request" do
      subject do
        described_class.request(
          username: username, password: password, path: path, method: :post, payload: payload
        ).second
      end

      it { is_expected.to eq some: "json" }
    end

    context "put request" do
      subject do
        described_class.request(
          username: username, password: password, path: path, method: :put, payload: payload
        ).second
      end

      it { is_expected.to eq some: "json" }
    end

    context "patch request" do
      subject do
        described_class.request(
          username: username, password: password, path: path, method: :patch, payload: payload
        ).second
      end

      it { is_expected.to eq some: "json" }
    end

    context "delete request" do
      subject do
        described_class.request(
          username: username, password: password, path: path, method: :delete
        ).second
      end

      it { is_expected.to eq some: "json" }
    end

    context "with a json parsing error on the response" do
      before do
        allow(JSON).to receive(:parse).and_raise JSON::ParserError
      end

      subject do
        described_class.request(
          username: username, password: password, path: path, method: :get
        ).second
      end

      it { is_expected.to be_nil }
    end

    context "when a block has been passed" do
      it "yields the expected times" do
        expect do |b|
          described_class.request username: username, password: password, path: path, method: :get,
                                  &b
        end.to yield_control.exactly(1).times
      end

      it "yields with the expected information" do
        expect do |b|
          described_class.request username: username, password: password, path: path, method: :get,
                                  &b
        end.to yield_with_args(anything, some: "json")
      end
    end
  end

  describe ".ok?" do

    context "with a successful response code" do
      before do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(
          OpenStruct.new(code: 200, body: '{ "some": "json" }')
        )
        # rubocop:enable RSpec/AnyInstance
      end

      it "returns true if a block is not given" do
        expect(
          described_class.ok?(username: username, password: password, path: path, method: :get)
        ).to eq true
      end

      it "yields with the expected information if a block is given" do
        expect do |b|
          described_class.ok?(username: username, password: password, path: path, method: :get, &b)
        end.to yield_with_args(some: "json")
      end
    end

    context "with an unsuccessful response code" do
      before do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(
          OpenStruct.new(code: 500, body: '{ "some": "json" }')
        )
        # rubocop:enable RSpec/AnyInstance
      end

      it "returns false if a block is not given" do
        expect(
          described_class.ok?(username: username, password: password, path: path, method: :get)
        ).to eq false
      end
    end

  end

end
