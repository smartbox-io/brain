require "spec_helper"

RSpec.describe AdminApi::V1::Cells::AcceptController do
  subject               { response }

  let(:admin)           { FactoryGirl.create :admin }
  let(:discovered_cell) { FactoryGirl.create :cell, status: :discovered }
  let(:accepted_cell)   { FactoryGirl.create :cell, status: :accepted }
  let(:headers)         { { headers: basic_auth(admin) } }

  context "cell is in discovered status" do
    def accept
      patch admin_api_v1_accept_path(discovered_cell.uuid), headers
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
      patch admin_api_v1_accept_path(accepted_cell.uuid), headers
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
