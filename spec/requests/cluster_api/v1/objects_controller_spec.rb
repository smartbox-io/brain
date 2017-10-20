require "spec_helper"

RSpec.describe ClusterApi::V1::ObjectsController do
  subject { response }

  let(:object) { FactoryGirl.create :full_object }
  let(:upload_token) { FactoryGirl.create :upload_token, user: object.user }
  let(:existing_object_params) do
    {
      upload_token: upload_token.token,
      client_ip:    upload_token.remote_ip,
      object:       {
        uuid:      object.uuid,
        name:      object.name,
        size:      object.size,
        md5sum:    object.md5sum,
        sha1sum:   object.sha1sum,
        sha256sum: object.sha256sum
      }
    }
  end

  let(:missing_object_params) do
    {
      upload_token: upload_token.token,
      client_ip:    upload_token.remote_ip,
      object:       {
        uuid:      SecureRandom.uuid,
        name:      object.name,
        size:      object.size,
        md5sum:    object.md5sum,
        sha1sum:   object.sha1sum,
        sha256sum: object.sha256sum
      }
    }
  end

  def create(existing_object: true)
    params = (existing_object ? existing_object_params : missing_object_params).to_json
    post cluster_api_v1_objects_path, params:  params,
                                      headers: token_auth(upload_token.user)
                                        .merge(json_content_type)
                                        .merge(ip(upload_token.cell.ip_address))
  end

  describe "#create" do
    context "existing object" do
      it "creates a new replica" do
        expect { create }.to change { object.replicas.count }.by 1
      end

      it "queues a converge job for that object" do
        expect { create }.to have_enqueued_job(ConvergeObjectJob)
      end

      it "updates the replica status" do
        expect { create }.to change { object.replicas.pluck(:status) }.from([]).to ["healthy"]
      end

      it "destroys the upload token" do
        expect { create }.to change { UploadToken.exists?(token: upload_token.token) }.from(true)
                                                                                      .to(false)
      end
    end

    context "missing object" do
      it "creates a new object" do
        expect { create existing_object: false }.to change { FullObject.count }.by_at_least 1
      end
    end
  end

  describe "#create" do
    before { create }

    it { is_expected.to have_http_status :ok }
  end
end
