require "rails_helper"

RSpec.describe AdminApi::V1::Cells::AcceptController do

  subject               { response }

  let(:admin)           { FactoryGirl.create :admin }
  let(:discovered_cell) { FactoryGirl.create :cell, status: :discovered }
  let(:accepted_cell)   { FactoryGirl.create :cell, status: :accepted }
  let(:headers)         { { headers: basic_auth(admin) } }

  context "cell is in discovered status" do
    let(:request) do
      patch admin_api_v1_accept_path(discovered_cell.uuid, format: :json), headers
    end

    it "sets the cell in accepted status" do
      expect { request }.to change { discovered_cell.reload.status }.from("discovered")
                                                                    .to("accepted")
    end

    describe "http return status" do
      before do
        request
      end

      it { is_expected.to have_http_status(:ok) }
    end
  end

  context "cell is not in discovered status" do
    let(:request) do
      patch admin_api_v1_accept_path(accepted_cell.uuid, format: :json), headers
    end

    it "does not change cell status" do
      expect { request }.not_to(change { discovered_cell.reload.status })
    end

    describe "http return status" do
      before do
        request
      end

      it { is_expected.to have_http_status(:forbidden) }
    end
  end

end
