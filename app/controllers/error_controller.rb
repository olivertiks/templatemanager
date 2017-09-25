class ErrorController < ApplicationController
  #before_action :set_error, only: [:show, :edit, :update, :destroy]

  # GET /errors
  # GET /errors.json
  def index
    #@errors = Error.all
    if Setting.first.developermode?
      logger.info "Developer settings activated, bypassing API check"
    else

      begin
      api_response = Http.get("http://localhost:1337", {})
      redirect_to root_path

      rescue StandardError
      end
    end
  end

  # GET /errors/1
  # GET /errors/1.json
  def show
  end

  # GET /errors/new
  def new
    @error = Error.new
  end

  def api_not_found
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_error
      @error = Error.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def error_params
      params.require(:error).permit(:api_error)
    end
end
