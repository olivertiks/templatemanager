class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  # GET /settings.json
  def index
    @setting = Setting.first
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
  end

  def setup
    # Don't show default layout, we'll create our own
    render :layout => false
  end

  def apisetup
    render :layout => false
    apisetting = Setting.first
  end
  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  def create
  end

  def rdpsetup
    # Don't show default layout, we'll create our own
    render :layout => false
  end

  def createmaster
    # Don't show default layout, we'll create our own
    render :layout => false
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
  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update

    if @setting.update(setting_params)
      flash[:notice] = "Settings updated successfully!"
    else
      flash[:notice] = "Error when updating settings."
    end

    respond_to do |format|
      format.html { render :index }
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
  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:apiserver, :defrdpuser, :defrdpsecret, :developermode)
    end

    def valid_json?(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end
end
