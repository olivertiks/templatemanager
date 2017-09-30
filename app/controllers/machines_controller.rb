class MachinesController < ApplicationController
  before_action :set_machine, only: [:show, :edit, :update, :destroy]
  before_action :verify_api
  # GET /machines
  # GET /machines.json
  def index
    Machine.discover
    @machines = Machine.all
    #puts @machines
  end

  # GET /machines/1
  # GET /machines/1.json
  def show
  end

  # GET /machines/new
  def new
    @machine = Machine.new
  end

  # GET /machines/1/edit
  def edit
  end

  # POST /machines
  # POST /machines.json
  def create
    @machine = Machine.new(machine_params)

    respond_to do |format|
      if @machine.save
        format.html { redirect_to @machine, notice: 'Machine was successfully created.' }
        format.json { render :show, status: :created, location: @machine }
      else
        format.html { render :new }
        format.json { render json: @machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machines/1
  # PATCH/PUT /machines/1.json
  def update
    respond_to do |format|
      format.html
    end
    #respond_to do |format|
    #  if @machine.update(machine_params)
    #    format.html { redirect_to @machine, notice: 'Machine was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @machine }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @machine.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # Attempts to set the state for Virtual Machine
  def setstate
    vm = Machine.find(params[:id])

    if vm.status == "running"
      newstate = "poweroff"
    else
      newstate = "running"
    end

    logger.info "MACHINE STATE IS #{vm.status}. CHANGING VM STATE TO #{newstate}"
    vm.set_state(newstate)

    logger.info "REQUERYING DATA ABOUT #{vm.identifier}"
    vm.requery()

    logger.info "CURRENT VM #{vm.identifier} STATE IS #{vm.status}"

    vm.activities.create(action: "State changed to: #{newstate}", date: Time.now, initiated_by: "Karl Erik")
    
    logger.info "#{vm.name}: changing VM state to #{newstate}"

    @machine = Machine.find(params[:id])

    respond_to do |format|
      format.js
    end

  end
  # DELETE /machines/1
  # DELETE /machines/1.json
  def destroy
    @machine.destroy
    respond_to do |format|
      format.html { redirect_to machines_url, notice: 'Machine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Tests the availiability of API before showing content
    def verify_api

    if Setting.first.developermode?
      logger.info "Developer settings activated, bypassing API check"
    else


      begin
        @apiserver = Setting.first.apiserver
        logger.info "Testing API backend"
        request = Http.get(@apiserver, {})
        response = JSON.parse(request.body)
      rescue StandardError
        logger.info "API backend at #{@apiserver} is not accessible :("
        redirect_to error_api_not_found_path
      end
      logger.info "API backend testing finished"
    end

    end
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def machine_params
      params.fetch(:machine, {})
    end
end
