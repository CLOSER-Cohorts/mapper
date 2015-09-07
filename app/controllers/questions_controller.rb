class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :set_topic, :add_variable, :remove_variable]
  before_action :set_instrument, only: [:index, :new, :create]

  # GET instrument/1/questions
  # GET /instrument/1/questions.json
  def index
    if params.has_key?(:queries)
      @questions = @instrument.questions.where('qc LIKE ? OR literal LIKE ?', "%#{params[:queries][:search]}%", "%#{params[:queries][:search]}%")
    else
      @questions = @instrument.questions
    end
    if params.has_key?(:sorts)
      if params[:sorts].values[0].to_i == 1
        @questions = @questions.order(params[:sorts].keys[0])
      else
        @questions = @questions.order(params[:sorts].keys[0] + " DESC")
      end
    end
    #@questions = Kaminari.paginate_array(@questions).page(params[:page].to_i).per(params[:perPage].to_i)
    render layout: "index"
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = @instrument.questions.new
    #@question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = @instrument.questions.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to instrument_path, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to instrument_questions_path, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @instrument = @question.instrument
    @question.destroy
    respond_to do |format|
      format.html { redirect_to instrument_url(@instrument), notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /questions/1/set_topic.json
  def set_topic
    if params.has_key?(:topic_id)
      @question.topic = Topic.find_by_id(params[:topic_id])
    end
    respond_to do |format|
      format.json { render json: true, status: :accepted }
    end
  end

  # POST /questions/1/add_variable.json
  def add_variable
    if params.has_key?(:variable_names) 
      params[:variable_names].each do |var_name|
        variable = Variable.find_by name: var_name
        if not variable.nil? and not @question.variables.find_by_id(variable.id)
          if params.has_key?(:x) && params.has_key?(:y)
            @question.map.create(:variable => variable, :x => params[:x].to_i, :y => params[:y].to_i)
          else
            @question.variables << variable
          end
        end
      end
    end
    respond_to do |format|
      format.json { render json: true, status: :accepted }
    end
  end

  # POST /questions/1/remove_variable.json
  def remove_variable
    @question.variables.delete(Variable.find(params[:variable_id]))
    respond_to do |format|
      format.json { render json: true, status: :accepted }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end
    def set_instrument
      @instrument = Instrument.includes(questions: [{parent: :topic},:topic, :variables]).find(params[:instrument_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params[:question].permit(:instrument_id, :qc, :literal)
    end
end
