require "rails_helper"

RSpec.describe "Cell management" do

  let!(:admin)          { FactoryGirl.create :admin }
  let(:discovered_cell) { FactoryGirl.create :cell, status: :discovered }
  let(:accepted_cell)   { FactoryGirl.create :cell, status: :accepted }

  context "cell is in discovered status" do
    it  "sets the cell in accepted status" do
      expect {
        patch admin_api_v1_accept_path(discovered_cell.uuid, format: :json),
              headers: basic_auth(admin)
      }.to change { discovered_cell.reload.status }.from("discovered").to("accepted")
      expect(response).to have_http_status(:ok)
    end
  end

  context "cell is not in discovered status" do
    it "does not change cell status" do
      expect {
        patch admin_api_v1_accept_path(accepted_cell.uuid, format: :json),
              headers: basic_auth(admin)
      }.not_to change { discovered_cell.reload.status }
      expect(response).to have_http_status(:forbidden)
    end
  end

end
