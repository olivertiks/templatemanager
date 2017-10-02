# Stores dashboard's initial, mandatory settings
class Setting
  include Mongoid::Document

  # API settings
  field :apiserver, type: String
  field :apiport, type: String

  # RDP settings
  field :defrdpuser, type: String
  field :defrdpsecret, type: String

  # Developer mode
  field :developermode, type: Boolean

  # Tests the availiability of API before showing content
    def api_live?

    # Skip the test if developer settings are activated

      begin

        host = Setting.first.apiserver
        port = Setting.first.apiport

        uri = URI.parse("http://#{host}:#{port}")

        Net::HTTP.start(host, port) do |http|
          http.read_timeout = 2
          request = Net::HTTP::Get.new uri
          response = http.request request # Net::HTTPResponse object
          if valid_json?(response.body)
            # ok
          else
            raise StandardError
          end
        end
      rescue StandardError
        logger.info "API server not reachable"
        redirect_to error_api_not_found_path
      end

    end #def
end
