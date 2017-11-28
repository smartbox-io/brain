require "spec_helper"

RSpec.describe AdminApi::V1::CellsController do
  subject { response }

  let(:admin)      { FactoryBot.create :admin }
  let(:admin_auth) { basic_auth admin }

  describe "#index" do
    before { get admin_api_v1_cells_path, headers: admin_auth }

    it { is_expected.to have_http_status :ok }
  end
end
