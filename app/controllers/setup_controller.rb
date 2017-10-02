class SetupController < ApplicationController
before_action :verify_setup_availability, :except => [:locked]

def index
	render :layout => false
end

def lock

	setup = Setup.first_or_create
	setup.locked = true
	if setup.save
		@lockresponse = "Setup Wizard locked successfully. You may continue now."
	else
		@lockresponse = "Error when locking Setup Wizard."
	end
  respond_to do |format|
    format.js
  end
end

def apisetup
  render :layout => false
  apisetting = Setting.first
end

  def finalized
    # Don't show default layout, we'll create our own
    render :layout => false
  end
  
  def locked
  	render :layout => false
  end

  def rdpsetup
    # Don't show default layout, we'll create our own
    render :layout => false
  end

    def createmaster
    # Don't show default layout, we'll create our own
    render :layout => false
  end

    def masterinitialize
    logger.info "Attempting to create administrator account"
    puts "Creating master account with email '#{params[:user][:email]}'"

     u = User.new(email: params[:user][:email], password: params[:user][:password], password_confirmation: params[:user][:password])
      if u.save
        @status = "Master account was created!"
      else
        @status = "Error while creating master account: #{u.errors.first}"
      end
  end

    def finalized
    # Don't show default layout, we'll create our own
    render :layout => false
  end

    def rdpinitialize
    logger.info "Starting RDP initializing process"

    setting = Setting.first_or_create

    user = params[:setting][:defrdpuser]
    secret = params[:setting][:defrdpsecret]

    setting.defrdpuser = user
    setting.defrdpsecret = secret

    if setting.save!
      @alertinfo = "RDP settings successfully initialized. You can proceed now :)"
    else
      @alertinfo = "Could not initialize RDP settings."
    end

    respond_to do |format|
      format.js
    end
  end

  def apiupdate

    begin
    logger.info "Submitted API server details: #{params[:setting][:apiserver]}, API port: #{params[:setting][:apiport]}"

    host = params[:setting][:apiserver]
    port = params[:setting][:apiport]

    uri = URI.parse("http://#{host}:#{port}/machine")
    Net::HTTP.start(host, port) do |http|
      http.read_timeout = 2
      request = Net::HTTP::Get.new uri
      response = http.request request # Net::HTTPResponse object

      if valid_json?(response.body)
        setup = Setting.first_or_create
        setup.apiserver = host
        setup.apiport = port
        setup.save!

        @alertinfo = "API server was reached! You can proceed now."
      else
        raise StandardError
      end
    end
  rescue StandardError
    @alertinfo = "API not reached. Please verify your data is valid."
    end
    respond_to do |format|
      format.js
    end

end

private

def verify_setup_availability
begin
	if Setup.first.locked == true
		logger.info "SETUP IS LOCKED"
		redirect_to setup_locked_path
	else
		logger.info "Someone is accessing setup wizard. As it's not locked, we'll let them proceed."
	end
rescue NoMethodError
	logger.info "Someone is accessing setup wizard. As it's not locked, we'll let them proceed."
end
end

    def valid_json?(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end
end
