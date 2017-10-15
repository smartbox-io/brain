require "rails_helper"

RSpec.describe "Cell management" do

  subject               { response }

  let!(:admin)          { FactoryGirl.create :admin }
  let(:discovered_cell) { FactoryGirl.create :cell, status: :discovered }
  let(:accepted_cell)   { FactoryGirl.create :cell, status: :accepted }

  context "cell is in discovered state" do
    before do
      patch admin_api_v1_accept_path(discovered_cell.uuid, format: :json),
            headers: basic_auth(admin)
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context "cell is not in discovered state" do
    before do
      patch admin_api_v1_accept_path(accepted_cell.uuid, format: :json),
            headers: basic_auth(admin)
    end

    it { is_expected.to have_http_status(:forbidden) }
  end

end
