require "spec_helper"

RSpec.describe AdminApi::V1::Cells::AcceptController do
  subject { response }

  let(:admin)           { FactoryBot.create :admin }
  let(:discovered_cell) { FactoryBot.create :cell, status: :discovered }
  let(:accepted_cell)   { FactoryBot.create :cell, status: :accepted }
  let(:admin_auth)      { basic_auth admin }

  context "cell is in discovered status" do
    def accept
      post admin_api_v1_accept_path(discovered_cell.uuid),
           params: {
             cell: {
               volumes: discovered_cell.volumes.pluck(:volume)
             }
           }, headers: admin_auth
    end

    it "sets the cell in accepted status" do
      expect { accept }.to change { discovered_cell.reload.status }.from("discovered")
                                                                   .to("accepted")
    end

    describe "http response" do
      before { accept }

      it { is_expected.to have_http_status :ok }
    end
  end

  context "cell is not in discovered status" do
    def accept
      post admin_api_v1_accept_path(accepted_cell.uuid),
           params: {
             cell: {
               volumes: []
             }
           }, headers: admin_auth
    end

    it "does not change cell status" do
      expect { accept }.not_to(change { discovered_cell.reload.status })
    end

    describe "http response" do
      before { accept }

      it { is_expected.to have_http_status :forbidden }
    end
  end
end
