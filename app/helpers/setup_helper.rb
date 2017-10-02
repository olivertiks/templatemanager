module SetupHelper

	def apistatuscheck
		begin

        host = Setting.first.apiserver
        port = Setting.first.apiport

        uri = URI.parse("http://#{host}:#{port}")

        Net::HTTP.start(host, port) do |http|
          http.read_timeout = 2
          request = Net::HTTP::Get.new uri
          response = http.request request # Net::HTTPResponse object
          if valid_json?(response.body)
            "<li><i class='material-icons' style='color: #1de9b6;'>check_circle</i>API server was reached at #{host}:#{port}</li>".html_safe
          else
            raise StandardError
          end
        end
      rescue StandardError
        "<li><i class='material-icons' style='color: #ef5350;'>check_circle</i>API server was not reached</li>".html_safe
      end
  end

    # Validate JSON response from given string
    def valid_json?(json)
      begin
        JSON.parse(json)
        return true
      rescue JSON::ParserError => e
        return false
      end
    end

    def rdpcredentialscheck
    	begin
    		if Setting.first.defrdpuser.nil?
    			raise StandardError
    		end

    		if Setting.first.defrdpsecret.nil?
    			raise StandardError
    		end

    		"<li><i class='material-icons' style='color: #1de9b6;'>check_circle</i>RDP credentials were initialized successfully</li>".html_safe
    	rescue StandardError
    		"<li><i class='material-icons' style='color: #ef5350;'>check_circle</i>RDP credentials were not initialized".html_safe
    	end
    end

    def masteraccountcheck
    	begin
    		if User.first.email.nil?
    			raise StandardError
    		else
    			"<li><i class='material-icons' style='color: #1de9b6;'>check_circle</i>Master account #{User.first.email} was created</li>".html_safe
    		end
    	rescue StandardError
    		"<li><i class='material-icons' style='color: #ef5350;'>check_circle</i>Master account was not registered</li>".html_safe
    	end
    end
end
