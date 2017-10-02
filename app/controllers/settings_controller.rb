class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :show, :edit, :create, :update, :destroy]

  # GET /settings
  # GET /settings.json
  def index
    @setting = Setting.first
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
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

end
