class VariablesController < ApplicationController
  before_action :set_variable, only: [:show, :edit, :update, :destroy, :set_topic, :add_question, :remove_question, :add_variable, :remove_variable]
  before_action :set_instrument, only: [:index, :new, :create]

  # GET /variables
  # GET /variables.json
  def index
    @topics = Topic.get_in_level_order
    @variables = @instrument.variables
    render layout: "index"
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
      format.html { redirect_to instrument_url(@instrument), notice: 'Variable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /variables/1/set_topic.json
  def set_topic
    if params.has_key?(:topic_id)
      @variable.topic = Topic.find_by_id(params[:topic_id])
    end
    respond_to do |format|
      format.json { render json: true, status: :accepted }
    end
  end
  
  # POST /variables/1/add_question.json
  def add_question
    if params.has_key?(:qcs) 
      params[:qcs].each do |qc|
        question = Question.find_by_qc qc
        if not question.nil? and not @variable.questions.find_by_id(question.id)
          @variable.questions << question
        end
      end
    end
    respond_to do |format|
      format.json { render json: true, status: :accepted }
    end
  end

  # POST /variables/1/remove_question.json
  def remove_question
    @variable.questions.delete(Question.find(params[:question_id]))
    respond_to do |format|
      format.json { render json: true, status: :accepted }
    end
  end

  # POST /variables/1/add_variable.json
  def add_variable
    if params.has_key?(:variable_names)
      params[:variable_names].each do |var_name|
        variable = Variable.find_by name: var_name
        if not variable.nil? and not @variable.src_variables.find_by_id(variable.id)
          @variable.src_variables << variable
        end
      end
    end
    respond_to do |format|
      format.json { render json: true, status: :accepted }
    end
  end

  # POST /questions/1/remove_variable.json
  def remove_variable
    @variable.src_variables.delete(Variable.find(params[:variable_id]))
    respond_to do |format|
      format.json { render json: true, status: :accepted }
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
