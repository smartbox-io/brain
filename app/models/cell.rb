class Cell < ApplicationRecord
  has_many :volumes, class_name: "CellVolume", dependent: :destroy
  has_many :object_backups, through: :volumes
  has_many :object_replicas, through: :volumes
  has_many :sync_source_tokens, through: :volumes
  has_many :sync_target_tokens, through: :volumes

  enum status: [:discovered, :accepted, :healthy, :unhealthy]

  def accept
    return false if self.status != "discovered"
    self.update_column :status, :healthy
  end

  def request(path:, method: :get, payload: nil, query: nil, access_token: nil)
    require "net/http"
    uri = URI("http://#{self.ip_address}#{path}")
    uri.query = URI.encode_www_form(query) if query
    http = Net::HTTP.new uri.host, uri.port
    req = case method
          when :head
            Net::HTTP::Head.new uri.request_uri
          when :get
            Net::HTTP::Get.new uri.request_uri
          when :post
            Net::HTTP::Post.new uri.request_uri, { "Content-Type" => "application/json" }
          when :put
            Net::HTTP::Put.new uri.request_uri, { "Content-Type" => "application/json" }
          when :patch
            Net::HTTP::Patch.new uri.request_uri, { "Content-Type" => "application/json" }
          when :delete
            Net::HTTP::Delete.new uri.request_uri
          else
            raise "unknown method"
          end
    if access_token
      req["Authorization"] = "Bearer #{access_token}"
    end
    if !%i(head get delete).include?(method) && payload
      req.body = payload.to_json
    end
    response = http.request req
    json_response = JSON.parse response.body, symbolize_names: true rescue nil
    if block_given?
      yield response, json_response
    else
      return response, json_response
    end
  end
end
