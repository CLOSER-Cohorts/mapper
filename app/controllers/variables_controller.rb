class VariablesController < ApplicationController
  before_action :set_variable, only: [:show, :edit, :update, :destroy]
  before_action :set_instrument, only: [:index, :new, :create]

  # GET /variables
  # GET /variables.json
  def index
    @variables = @instrument.variables
  end

  # GET /variables/1
  # GET /variables/1.json
  def show
  end

  # GET /variables/new
  def new
    @variable = @instrument.variables.new
  end

  # GET /variables/1/edit
  def edit
  end

  # POST /variables
  # POST /variables.json
  def create
    @variable = @instrument.variables.new(variable_params)

    respond_to do |format|
      if @variable.save
        format.html { redirect_to @variable, notice: 'Variable was successfully created.' }
        format.json { render :show, status: :created, location: @variable }
      else
        format.html { render :new }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variables/1
  # PATCH/PUT /variables/1.json
  def update
    respond_to do |format|
      if @variable.update(variable_params)
        format.html { redirect_to @variable, notice: 'Variable was successfully updated.' }
        format.json { render :show, status: :ok, location: @variable }
      else
        format.html { render :edit }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variables/1
  # DELETE /variables/1.json
  def destroy
    @instrument = @variable.instrument
    @variable.destroy
    respond_to do |format|
      format.html { redirect_to instrument_variables_url(@instrument), notice: 'Variable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable
      @variable = Variable.find(params[:id])
    end
    def set_instrument
      @instrument = Instrument.find(params[:instrument_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variable_params
      params[:variable].permit(:instrument_id, :name, :label, :var_type)
    end
end
