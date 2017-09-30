require "net/http"
require "uri"
require "json"

# Model to communicate with API's
class Http
  
  # Defines GET request
  # @param [String] path URI of API endpoint
  # @param [Array] params Params to be submitted with request
  def self.get(path, params)
    self.request :get, path, params
  end

  # Defines POST request
  # @param [String] path URI of API endpoint
  # @param [Array] params Params to be submitted with request
  def self.post(path, params)
  	self.request :post, path, params
  end

  # Defines PUT request
  # @param [String] path URI of API endpoint
  # @param [Array] params Params to be submitted with request
  def self.put(path, params)
  	self.request :put, path, params
  end

  # Defines DELETE request
  # @param [String] path URI of API endpoint
  # @param [Array] params Params to be submitted with request
  def self.delete(path, params)
  	self.request :delete, path, params
  end

  # Sends the HTTP request
  # @param [String] path URI of API endpoint
  # @param [String] method Method of request [GET/POST/PUT/DELETE]
  # @param [Array] params Param(s) to be submitted with request
  def self.request(method, path, params = {})
  	
  	uri = URI.parse(path)
  	headers = {"Content-Type" => "application/json"}
  	http = Net::HTTP.new(uri.host, uri.port)

  	if path.starts_with? "https://"
  		http.use_ssl = true
  		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  	end

  	http_method = {
  		:get    => Net::HTTP::Get,
  		:post   => Net::HTTP::Post,
  		:put    => Net::HTTP::Put,
  		:delete => Net::HTTP::Delete
  	}

  	request = http_method[method.to_sym].new(uri.request_uri, headers)
  	request.body = params.to_json

    http.request(request)
  end
end