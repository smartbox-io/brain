class BrainAdminApi
  require "net/http"

  # rubocop:disable Metrics/ParameterLists
  def self.request(username:, password:, path:, method: :get, payload: nil, query: nil)
    response = perform_request username: username, password: password, path: path, method: method,
                               payload: payload, query: query
    json_response = begin
                      JSON.parse response.body, symbolize_names: true
                    rescue JSON::ParserError
                      nil
                    end
    return response, json_response unless block_given?
    yield response, json_response
  end
  # rubocop:enable Metrics/ParameterLists

  # rubocop:disable Metrics/ParameterLists
  def self.ok?(username:, password:, path:, method: :get, payload: nil, query: nil)
    request(username: username, password: password, path: path, method: method, payload: payload,
            query: query) do |response, json_response|
      response.code.to_i.between?(200, 299).tap do |ok|
        yield(json_response) if ok && block_given?
      end
    end
  end
  # rubocop:enable Metrics/ParameterLists

  # rubocop:disable Metrics/ParameterLists
  def self.perform_request(username:, password:, path:, method:, payload:, query:)
    uri = URI("http://#{ENV["BRAIN_SERVICE_HOST"]}:#{ENV["BRAIN_SERVICE_PORT"]}#{path}")
    uri.query = URI.encode_www_form(query) if query
    http = Net::HTTP.new uri.host, uri.port
    req = build_request uri: uri, method: method
    req.basic_auth username, password
    req.body = payload.to_json if !%i[head get delete].include?(method) && payload
    http.request req
  end
  # rubocop:enable Metrics/ParameterLists

  # rubocop:disable Metrics/CyclomaticComplexity
  def self.build_request(uri:, method:)
    case method
    when :head   then Net::HTTP::Head.new   uri.request_uri
    when :get    then Net::HTTP::Get.new    uri.request_uri
    when :post   then Net::HTTP::Post.new   uri.request_uri, "Content-Type" => "application/json"
    when :put    then Net::HTTP::Put.new    uri.request_uri, "Content-Type" => "application/json"
    when :patch  then Net::HTTP::Patch.new  uri.request_uri, "Content-Type" => "application/json"
    when :delete then Net::HTTP::Delete.new uri.request_uri
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
end
