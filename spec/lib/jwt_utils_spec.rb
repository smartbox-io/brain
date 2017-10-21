require "spec_helper"
require "jwt_utils"

RSpec.describe JWTUtils do

  let(:payload) { { some: "payload" } }
  let(:jwt_with_expiration) { described_class.encode payload: payload }
  let(:jwt) { jwt_with_expiration.first }

  describe ".encode" do
    it "encodes the payload" do
      expect(jwt_with_expiration.count).to eq 2
    end

    it "has a jwt format" do
      expect(jwt).to match(/^([a-zA-Z0-9_-]+\.){2}[a-zA-Z0-9_-]+$/)
    end
  end

  describe ".decode" do
    it "decodes the payload" do
      expect(described_class.decode(jwt: jwt)).to match(payload:    { some: "payload" },
                                                        expiration: be_an_instance_of(Integer),
                                                        version:    "v1")
    end
  end

end
